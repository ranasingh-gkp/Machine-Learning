# Boltzmann Machines

# Importing the libraries
import numpy as np
import pandas as pd
import torch
import torch.nn as nn
import torch.nn.parallel
import torch.optim as optim
import torch.utils.data
from torch.autograd import Variable

# Importing the dataset
movies = pd.read_csv('ml-1m/movies.dat', sep = '::', header = None, engine = 'python', encoding = 'latin-1')
users = pd.read_csv('ml-1m/users.dat', sep = '::', header = None, engine = 'python', encoding = 'latin-1')
ratings = pd.read_csv('ml-1m/ratings.dat', sep = '::', header = None, engine = 'python', encoding = 'latin-1')

# Preparing the training set and the test set
#in data set mant no of training and test set are given(divided in 80% vs 20% ratio)
training_set = pd.read_csv('ml-100k/u1.base', delimiter = '\t')#delimiter is same as sep
training_set = np.array(training_set, dtype = 'int')# np.array- convert data frame into array
test_set = pd.read_csv('ml-100k/u1.test', delimiter = '\t')
test_set = np.array(test_set, dtype = 'int')

# ------Getting the number of users and movies
#find out maximum no of use and movies
#max no may present in training or test so "max(max" will find out max of them
nb_users = int(max(max(training_set[:,0]), max(test_set[:,0])))#int convert max no of user into integer 
nb_movies = int(max(max(training_set[:,1]), max(test_set[:,1])))

# -----Converting the data into an array with users in lines and movies in columns
#creat no of list same as no of user (943 list), each list correspond to different user have features.
#each list have 1682 features(i.e rating of moving)..if user did not rate the move the value will be zero
def convert(data):
    new_data = []#contain list i.e will be our final array contain users in lines and movies in columns
    for id_users in range(1, nb_users + 1):   #range(1, nb_users) will go upto 942 because upperone excluded so add 1.
        id_movies = data[:,1][data[:,0] == id_users]#data[:,1] whole column of movie id  //.... [data[:,0] == id_users] will take all movie id of first user
        id_ratings = data[:,2][data[:,0] == id_users]# taking rating
        ratings = np.zeros(nb_movies)#list of zero 1682
        ratings[id_movies - 1] = id_ratings#index in python start at 0 and our movie start at 1 so basically we want movie id start at same base as indexof rating i.e 0 thats why subtract 1 from movie id. les example first user rated first movie and first movie has id_movie is 1.but first movie will be first element of rating list and first element of rating has index 0.therefor first movie need to put in first element of rating index we need to subtract 1. so it will go in first position in rating list , not in second.
        new_data.append(list(ratings))#adding list(ratings into new_data
    return new_data
training_set = convert(training_set)
test_set = convert(test_set)

# Converting the data into Torch tensors
training_set = torch.FloatTensor(training_set)#FloatTensor ecpect list of list in argument which we alrady done
test_set = torch.FloatTensor(test_set)

# ----------Converting the ratings into binary ratings 1 (Liked) or 0 (Not Liked)
#or operator does not work in pytorch
#RBM work on binary set
training_set[training_set == 0] = -1#not rating for specific movie given by specific user
training_set[training_set == 1] = 0# rating 1 & 2 are not liked by user so  in binary convert to 0
training_set[training_set == 2] = 0
training_set[training_set >= 3] = 1##more then 3 liked by user so in binary 1
test_set[test_set == 0] = -1
test_set[test_set == 1] = 0
test_set[test_set == 2] = 0
test_set[test_set >= 3] = 1

#-------- Creating the architecture of the Neural Network
#RBM is probabilistic model
class RBM():  #first letter should be capital
    def __init__(self, nv, nh):
        self.W = torch.randn(nh, nv)#initialise weight according to normal distribution
        self.a = torch.randn(1, nh)#for hidden node(2-D)tensor //  initialise bias according to normal distribution(first batch & second to bias)
        self.b = torch.randn(1, nv)#for visible node(2-D)tensor
    def sample_h(self, x):  #sample the hidden node(x correspond to visible node)
        wx = torch.mm(x, self.W.t())  #product of weight and node by function "mm"// self.W.t() here self.w is weight matrix and t() is use for transpose the weight matrix 
        activation = wx + self.a.expand_as(wx)#self.a.expand_as(wx) here bias a of self function added to weighht matrix in same vector(expand_as(wx))
        p_h_given_v = torch.sigmoid(activation)#activation function // p_h_given_v is the probability of hidden node given visible node using sigmoid function
        return p_h_given_v, torch.bernoulli(p_h_given_v)# 1 correspond to given by sampling if greater then probability and 0 correspond to not given by sampling 
    #p_h_given_v is vector of hidden element, each element correspond to each hidden node & each element is probability that hidden node activated.
    #ith element of this vector is the probability of ith hidden node activated given value of visible node
    # how avtivation done,, let take random no between 0 & 1 if no less then probability(p_h_given_v) then neuron are activated and if greater then p_h_given_v then neuronn not activated. thats how bernoulli work. so we will get vector of 0 & 1..1 corresponded to activated neurons and 0 correspond to non activated.
    def sample_v(self, y):#sample for visible node(see above)
        wy = torch.mm(y, self.W)#y correspond to hidden node
        activation = wy + self.b.expand_as(wy)
        p_v_given_h = torch.sigmoid(activation)
        return p_v_given_h, torch.bernoulli(p_v_given_h)
    def train(self, v0, vk, ph0, phk):#contrastive divergent predict log-likelihood gradient 
        self.W += torch.mm(v0.t(), ph0) - torch.mm(vk.t(), phk)
        self.b += torch.sum((v0 - vk), 0)#adding 0 to (v0 - vk) just to make vector of 2-D
        self.a += torch.sum((ph0 - phk), 0)
nv = len(training_set[0])# len(training_set[0]) is no of feature in first line
nh = 100#no of hidden node //  it is no of feature correspond to 1682 movie(nv) example actor,action, drama etc
batch_size = 100 # each one have same parameter i.e parameter update after 100 batch size
rbm = RBM(nv, nh)#call rbm with parameter

# Training the RBM
nb_epoch = 10
for epoch in range(1, nb_epoch + 1):
    train_loss = 0#loss measure RMSE
    s = 0.
    for id_user in range(0, nb_users - batch_size, batch_size):
        vk = training_set[id_user:id_user+batch_size]#input of rating in batch
        v0 = training_set[id_user:id_user+batch_size]#rating which are already rated by batch size
        ph0,_ = rbm.sample_h(v0)#contrastive divergent i.e probability of given hidden node given rating //  sample_h(v0) correspond to sample X at initial stage i.e v0
        for k in range(10): # k-step chaion contrastive divergent
            _,hk = rbm.sample_h(vk)
            _,vk = rbm.sample_v(hk)
            vk[v0<0] = v0[v0<0]
        phk,_ = rbm.sample_h(vk)
        rbm.train(v0, vk, ph0, phk)
        train_loss += torch.mean(torch.abs(v0[v0>=0] - vk[v0>=0]))
        s += 1.
    print('epoch: '+str(epoch)+' loss: '+str(train_loss/s))

# Testing the RBM
test_loss = 0
s = 0.
for id_user in range(nb_users):
    v = training_set[id_user:id_user+1]# training_set use to activate hidden neurons that is v output // training_set use to get the predicted rating of test set
    vt = test_set[id_user:id_user+1]#vt contain original rating of test set
    if len(vt[vt>=0]) > 0:
        _,h = rbm.sample_h(v)
        _,v = rbm.sample_v(h)
        test_loss += torch.mean(torch.abs(vt[vt>=0] - v[vt>=0]))
        s += 1.
print('test loss: '+str(test_loss/s))