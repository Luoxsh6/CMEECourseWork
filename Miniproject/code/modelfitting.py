#!/usr/bin/python

"""Seedlings image classification model fitting process"""

__author__ = 'Xiaosheng Luo'
__version__ = '1.0.0'


from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from xgboost import XGBClassifier
from sklearn.svm import SVC
from sklearn.model_selection import GridSearchCV
from sklearn.model_selection import train_test_split
from sklearn.metrics import roc_curve, auc, classification_report
from sklearn.preprocessing import label_binarize
from sklearn import metrics
import matplotlib.pyplot as plt
from mpl_toolkits.axes_grid1 import ImageGrid
import numpy as np
import pandas as pd
import os
import time
import cv2
from functions import *
import warnings

warnings.filterwarnings("ignore")

start = time.time()

# Set plt interactive mode
plt.ion()

# Check data
print("-" * 27, "\nData composition:")

train_dir = "../data/train"

CATEGORIES = ['Black-grass', 'Charlock', 'Cleavers', 'Common-Chickweed', 'Common-wheat', 'Fat-Hen', 'Loose-Silky-bent',
              'Maize', 'Scentless-Mayweed', 'Shepherds-Purse', 'Small-flowered-Cranesbill', 'Sugar-beet']

# check numbers of categories
NumCatergories = len(CATEGORIES)
print("Numbers of categories:", NumCatergories)

# check numbers of images
for category in CATEGORIES:
    print('{}: {} images'.format(category, len(os.listdir(os.path.join(train_dir, category)))))
print("-" * 27)

# create a dataframe for dataset including filename_path, catagory and id
train = []
for category_id, category in enumerate(CATEGORIES):
    for file in os.listdir(os.path.join(train_dir, category)):
        train.append(['../data/train/{}/{}'.format(category, file), category, category_id])
        
train = pd.DataFrame(train, columns=['file', 'category','category_id'])


# Show the sample images
fig = plt.figure(1, figsize=(NumCatergories, NumCatergories))
grid = ImageGrid(fig, 111, nrows_ncols=(NumCatergories, NumCatergories), axes_pad=0.05)

i = 0
for category_id, category in enumerate(CATEGORIES):
    for filepath in train[train['category'] == category]['file'].values[:NumCatergories]:
        ax = grid[i]
        img = read_img(filepath)
        ax.imshow(img)
        ax.axis('off')
        if i % NumCatergories == NumCatergories - 1:
            ax.text(250, 112, filepath.split('/')[3], verticalalignment='center')
        i += 1

print("display samples")
plt.pause(3)
plt.savefig('../results/sample_images.png', transparent=True)
print("saving images to ../results/sample_images.png")
print("-" * 27)
plt.close()

# Show how the images are processed
# read full images
img_eg = cv2.imread('../data/train/Maize/00a18f05e.png')
hsv_eg = cv2.cvtColor(img_eg, cv2.COLOR_BGR2HSV)
hls_eg = cv2.cvtColor(img_eg,cv2.COLOR_BGR2HLS)

# mask out images
image_segmented = segment_plant(img_eg)
image_segmented_hls = cv2.cvtColor(image_segmented,cv2.COLOR_BGR2HLS)
image_segmented_hsv = cv2.cvtColor(image_segmented,cv2.COLOR_BGR2HSV)

# show the historgram of img
for i in range(3):
        hist = cv2.calcHist([img_eg],[i],None,[128],[0,256])
        plt.plot(hist)

print("display histogram")
plt.pause(3)
plt.savefig('../results/histogram.png', transparent=True)
print("saving images to ../results/histogram.png")
print("-" * 27)
plt.close()

# show images
fig, axs = plt.subplots(1, 6, figsize=(20, 20))
axs[0].imshow(img_eg)
axs[1].imshow(hsv_eg)
axs[2].imshow(hls_eg)
axs[3].imshow(sharpen_image(image_segmented))
axs[4].imshow(sharpen_image(image_segmented_hsv))
axs[5].imshow(sharpen_image(image_segmented_hls))

print("show images after color space conversion and threshold mask")
plt.pause(3)
plt.savefig('../results/preprocess_images.png', transparent=True)
print("saving images to ../results/preprocess_images.png")
print("-" * 27)
plt.close()

# Load and process the images into different color space and histogram features
# initialize the raw pixel intensities matrix, the features matrix,
# and labels list
BGRImages = []
HSVImages = []
HLSImages = []
his_BGR = []
his_HSV = []
his_HLS = []
his_mask_BGR = []
his_mask_HSV = []
his_mask_HLS = []
labels = []

print("Load and processing the images into different color space and histogram features..")
# loop over the input images
for i, row in train.iterrows():
    # load the image and extract the class label
    # our images were named as labels.image_number.format
    image = cv2.imread(row['file'])
    # get the labels from the name of the images by extract the string before "."
    label = row['category_id']

    # extract raw pixel intensity "features"
    #followed by a color histogram to characterize the color distribution of the pixels
    # in the image
    
    resize_image = cv2.resize(image, (128, 128))
    bgrimage = resize_image.flatten()
    hsvimage = cv2.cvtColor(resize_image, cv2.COLOR_BGR2HSV).flatten()
    hlsimage = cv2.cvtColor(resize_image, cv2.COLOR_BGR2HLS).flatten()
    
    his_bgr = extract_BGR_histogram(resize_image)
    his_hsv = extract_HSV_histogram(resize_image)
    his_hls = extract_HLS_histogram(resize_image)
    
    image_mask = create_mask_for_plant(resize_image)
    image_mask_sharpen = sharpen_image(segment_plant(resize_image))
    his_mask_bgr = extract_BGR_histogram(image_mask_sharpen)
    his_mask_hsv = extract_HSV_histogram(image_mask_sharpen)
    his_mask_hls = extract_HLS_histogram(image_mask_sharpen)

    # add the messages we got to the raw images, features, and labels matricies
    BGRImages.append(bgrimage)
    HSVImages.append(hsvimage)
    HLSImages.append(hlsimage)
    his_BGR.append(his_bgr)
    his_HSV.append(his_hsv)
    his_HLS.append(his_hls)
    his_mask_BGR.append(his_mask_bgr)
    his_mask_HSV.append(his_mask_hsv)
    his_mask_HLS.append(his_mask_hls)
    labels.append(label)    

    # show an update every 400 images until the last image
    if i > 0 and ((i + 1)% 400 == 0 or i == train.shape[0]-1):
        print("[INFO] processed {}/{}".format(i+1, train.shape[0]))

print("[INFO] Done!\n", "-" * 27)


# show some information on the memory consumed by the raw images
# matrix and features matrix
BGRImages = np.array(BGRImages)
HSVImages = np.array(HSVImages)
HLSImages = np.array(HLSImages)
his_BGR = np.array(his_BGR)
his_HSV = np.array(his_HSV)
his_HLS = np.array(his_HLS)
his_mask_BGR = np.array(his_mask_BGR)
his_mask_HSV = np.array(his_mask_HSV)
his_mask_HLS = np.array(his_mask_HLS)
labels = np.array(labels)

print("Memory Consumed:")
print("[INFO] BGRImages matrix: {:.2f}MB".format(
    BGRImages.nbytes / (1024 * 1000.0)))
print("[INFO] his_BGR matrix: {:.2f}MB".format(
    his_BGR.nbytes / (1024 * 1000.0)))
print("[INFO] his_mask_BGR matrix: {:.2f}MB".format(
    his_mask_BGR.nbytes / (1024 * 1000.0)))
print("-" * 27)


# Partition the data i1nto training and testing splits, using 80%
# of the data for training and the remaining 15% for testing
(trainRI, testRI, trainRL, testRL) = train_test_split(
    BGRImages, labels, test_size=0.20, random_state=27)
(trainVI, testVI, trainVL, testVL) = train_test_split(
    HSVImages, labels, test_size=0.20, random_state=27)
(trainSI, testSI, trainSL, testSL) = train_test_split(
    HLSImages, labels, test_size=0.20, random_state=27)

(trainHBI, testHBI, trainHBL, testHBL) = train_test_split(
    his_BGR, labels, test_size=0.20, random_state=27)
(trainHVI, testHVI, trainHVL, testHVL) = train_test_split(
    his_HSV, labels, test_size=0.20, random_state=27)
(trainHSI, testHSI, trainHSL, testHSL) = train_test_split(
    his_HLS, labels, test_size=0.20, random_state=27)

(trainHMBI, testHMBI, trainHMBL, testHMBL) = train_test_split(
    his_mask_BGR, labels, test_size=0.20, random_state=27)
(trainHMVI, testHMVI, trainHMVL, testHMVL) = train_test_split(
    his_mask_HSV, labels, test_size=0.20, random_state=27)
(trainHMSI, testHMSI, trainHMSL, testHMSL) = train_test_split(
    his_mask_HLS, labels, test_size=0.20, random_state=27)

print("train_test_split:", "\nlen(train):", len(trainRI), "\nlen(test):", len(testRI))
print("-" * 27)


# k-NearestNeighbor 
print("Model fitting with k-NearestNeighbor")
# Find hyperparameter K based on HSV color space after masking & histogram
print("Find hyperparameter K based on HSV color space after masking & histogram")
training_accuracy = []
test_accuracy = []
# n_neighbors
neighbors_settings = range(1, 10)

for n_neighbors in neighbors_settings:
    clf = KNeighborsClassifier(n_neighbors=n_neighbors)
    clf.fit(trainHMVI, trainHMVL)
    training_accuracy.append(clf.score(trainHMVI, trainHMVL))
    test_accuracy.append(clf.score(testHMVI, testHMVL))

plt.plot(neighbors_settings, training_accuracy, label="training accuracy")
plt.plot(neighbors_settings, test_accuracy, label="test accuracy")
plt.ylabel("Accuracy")
plt.xlabel("n_neighbors")
plt.legend()
plt.pause(3)
plt.savefig('../results/find_hyperparameterK.png', transparent=True)
print("saving images to ../results/find_hyperparameterK.png")
print("-" * 27)
plt.close()

# KNN with different color space raw pixels
# set hyperparameter K
NeigborsNum = 9

# k-NN BGR raw pixels
print("[INFO] evaluating BGR raw pixels Images classification accuracy...")
tic = time.time()

model1 = KNeighborsClassifier(n_neighbors=NeigborsNum)
model1.fit(trainRI, trainRL)
acc_train = model1.score(trainRI, trainRL)
acc_test = model1.score(testRI, testRL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] k-NN classifier: k={}".format(NeigborsNum))
print("[INFO] BGR Raw Pixels training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] BGR Raw Pixels test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] BGR Raw Pixels Images k-NN classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))

# k-NN HSV raw pixels
print("\n[INFO] evaluating HSV raw pixels Images classification accuracy...")
tic = time.time()

model2 = KNeighborsClassifier(n_neighbors= NeigborsNum)
model2.fit(trainVI, trainVL)
acc_train = model2.score(trainVI, trainVL)
acc_test = model2.score(testVI, testVL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] k-NN classifier: k={}".format(NeigborsNum))
print("[INFO] HSV Raw Pixels training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HSV Raw Pixels test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HSV Raw Pixels Images k-NN classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))

# k-NN HLS raw pixels
print("\n[INFO] evaluating HSL raw pixels Images classification accuracy...")
tic = time.time()

model3 = KNeighborsClassifier(n_neighbors= NeigborsNum)
model3.fit(trainSI, trainSL)
acc_train = model3.score(trainSI, trainSL)
acc_test = model3.score(testSI, testSL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] k-NN classifier: k={}".format(NeigborsNum))
print("[INFO] HLS Raw Pixels training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HLS Raw Pixels test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HLS Raw Pixels Images k-NN classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))
print("-" * 27)

# KNN with different color space histograms
# k-NN BGR_hisogram
print("[INFO] evaluating BGR hisogram accuracy...")
tic = time.time()

model4 = KNeighborsClassifier(n_neighbors= NeigborsNum)
model4.fit(trainHBI, trainHBL)
acc_train = model4.score(trainHBI, trainHBL)
acc_test = model4.score(testHBI, testHBL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] k-NN classifier: k={}".format(NeigborsNum))
print("[INFO] BGR hisograms training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] BGR hisograms test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] BGR hisograms k-NN classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))

# k-NN HSV_hisogram
print("\n[INFO] evaluating HSV hisogram accuracy...")
tic = time.time()

model5 = KNeighborsClassifier(n_neighbors= NeigborsNum)
model5.fit(trainHVI, trainHVL)
acc_train = model5.score(trainHVI, trainHVL)
acc_test = model5.score(testHVI, testHVL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] k-NN classifier: k={}".format(NeigborsNum))
print("[INFO] HSV hisograms training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HSV hisograms test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HSV hisograms k-NN classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))

# k-NN HLS_hisogram
print("\n[INFO] evaluating HLS hisogram accuracy...")
tic = time.time()

model6 = KNeighborsClassifier(n_neighbors= NeigborsNum)
model6.fit(trainHSI, trainHSL)
acc_train = model6.score(trainHSI, trainHSL)
acc_test = model6.score(testHSI, testHSL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] k-NN classifier: k={}".format(NeigborsNum))
print("[INFO] HLS hisograms training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HLS hisograms test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HLS hisograms k-NN classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))
print("-" * 27)

# KNN with different color space histograms after masking
# k-NN BGR_hisogram after masking
print("[INFO] evaluating BGR hisograms after masking accuracy...")
tic = time.time()

model7 = KNeighborsClassifier(n_neighbors= NeigborsNum)
model7.fit(trainHMBI, trainHMBL)
acc_train = model7.score(trainHMBI, trainHMBL)
acc_test = model7.score(testHMBI, testHMBL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] k-NN classifier: k={}".format(NeigborsNum))
print("[INFO] BGR hisograms after masking training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] BGR hisograms after masking test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] BGR hisograms after masking k-NN classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))

# k-NN HLS_hisogram after masking
print("\n[INFO] evaluating HLS hisograms after masking accuracy...")
tic = time.time()

model8 = KNeighborsClassifier(n_neighbors= NeigborsNum)
model8.fit(trainHMSI, trainHMSL)
acc_train = model8.score(trainHMSI, trainHMSL)
acc_test = model8.score(testHMSI, testHMSL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] k-NN classifier: k={}".format(NeigborsNum))
print("[INFO] HLS hisograms after masking training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HLS hisograms after masking test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HLS hisograms after masking k-NN classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))

# k-NN HSV_hisogram after masking
print("\n[INFO] evaluating HSV hisograms after masking accuracy...")
tic = time.time()

model9 = KNeighborsClassifier(n_neighbors= NeigborsNum)
model9.fit(trainHMVI, trainHMVL)
acc_train = model9.score(trainHMVI, trainHMVL)
acc_test = model9.score(testHMVI, testHMVL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] k-NN classifier: k={}".format(NeigborsNum))
print("[INFO] HSV hisograms after masking training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HSV hisograms after masking test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HSV hisograms after masking k-NN classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))
print("-" * 27)

# KNN Model evaluation ROC
# consider using dynamically generated variables
# prediction probability of each class by all classifier
y_scoreknn1 = model1.predict_proba(testRI)
y_scoreknn2 = model2.predict_proba(testVI)
y_scoreknn3 = model3.predict_proba(testSI)
y_scoreknn4 = model4.predict_proba(testHBI)
y_scoreknn5 = model5.predict_proba(testHVI)
y_scoreknn6 = model6.predict_proba(testHSI)
y_scoreknn7 = model7.predict_proba(testHMBI)
y_scoreknn8 = model8.predict_proba(testHMSI)
y_scoreknn9 = model9.predict_proba(testHMVI)

# test lables one-hot conversion
testRL_onehot = label_binarize(testRL, np.arange(12))
testVL_onehot = label_binarize(testVL, np.arange(12))
testSL_onehot = label_binarize(testSL, np.arange(12))
testHBL_onehot = label_binarize(testHBL, np.arange(12))
testHVL_onehot = label_binarize(testHVL, np.arange(12))
testHSL_onehot = label_binarize(testHSL, np.arange(12))
testHMBL_onehot = label_binarize(testHMBL, np.arange(12))
testHMSL_onehot = label_binarize(testHMSL, np.arange(12))
testHMVL_onehot = label_binarize(testHMVL, np.arange(12))

# calculate AUC
fprknn1, tprknn1, thresholds = metrics.roc_curve(testRL_onehot.ravel(),y_scoreknn1.ravel())
aucknn1 = metrics.auc(fprknn1, tprknn1)
fprknn2, tprknn2, thresholds = metrics.roc_curve(testVL_onehot.ravel(),y_scoreknn2.ravel())
aucknn2 = metrics.auc(fprknn2, tprknn2)
fprknn3, tprknn3, thresholds = metrics.roc_curve(testSL_onehot.ravel(),y_scoreknn3.ravel())
aucknn3 = metrics.auc(fprknn3, tprknn3)
fprknn4, tprknn4, thresholds = metrics.roc_curve(testHBL_onehot.ravel(),y_scoreknn4.ravel())
aucknn4 = metrics.auc(fprknn4, tprknn4)
fprknn5, tprknn5, thresholds = metrics.roc_curve(testHVL_onehot.ravel(),y_scoreknn5.ravel())
aucknn5 = metrics.auc(fprknn5, tprknn5)
fprknn6, tprknn6, thresholds = metrics.roc_curve(testHSL_onehot.ravel(),y_scoreknn6.ravel())
aucknn6 = metrics.auc(fprknn6, tprknn6)
fprknn7, tprknn7, thresholds = metrics.roc_curve(testHMBL_onehot.ravel(),y_scoreknn7.ravel())
aucknn7 = metrics.auc(fprknn7, tprknn7)
fprknn8, tprknn8, thresholds = metrics.roc_curve(testHMSL_onehot.ravel(),y_scoreknn8.ravel())
aucknn8 = metrics.auc(fprknn8, tprknn8)
fprknn9, tprknn9, thresholds = metrics.roc_curve(testHMVL_onehot.ravel(),y_scoreknn9.ravel())
aucknn9 = metrics.auc(fprknn9, tprknn9)

# plot the ROC curve
print("Show KNN classifier ROC curve")
plt.plot(fprknn1, tprknn1, c = 'r', lw = 2, ls = '--', alpha = 0.7, label = u'rawRGBAUC=%.3f' % aucknn1)
plt.plot(fprknn2, tprknn2, c = 'r', lw = 2, ls = ':', alpha = 0.7, label = u'rawHSVAUC=%.3f' % aucknn2)
plt.plot(fprknn3, tprknn3, c = 'r', lw = 2, ls = '-.', alpha = 0.7, label = u'rawHSLAUC=%.3f' % aucknn3)
plt.plot(fprknn4, tprknn4, c = 'g', lw = 2, ls = '--', alpha = 0.7, label = u'hisRGBAUC=%.3f' % aucknn4)
plt.plot(fprknn5, tprknn5, c = 'g', lw = 2, ls = ':', alpha = 0.7, label = u'hisHSVAUC=%.3f' % aucknn5)
plt.plot(fprknn6, tprknn6, c = 'g', lw = 2, ls = '-.', alpha = 0.7, label = u'hisHSLAUC=%.3f' % aucknn6)
plt.plot(fprknn7, tprknn7, c = 'b', lw = 2, ls = '--', alpha = 0.7, label = u'maskRGBAUC=%.3f' % aucknn7)
plt.plot(fprknn8, tprknn8, c = 'b', lw = 2, ls = ':', alpha = 0.7, label = u'maskHSLAUC=%.3f' % aucknn8)
plt.plot(fprknn9, tprknn9, c = 'b', lw = 2, ls = '-.', alpha = 0.7, label = u'maskHSVAUC=%.3f' % aucknn9)
plt.plot((0, 1), (0, 1), c = '#808080', lw = 1, ls = '--', alpha = 0.7)
plt.xlim((-0.01, 1.02))
plt.ylim((-0.01, 1.02))
plt.xticks(np.arange(0, 1.1, 0.1))
plt.yticks(np.arange(0, 1.1, 0.1))
plt.xlabel('False Positive Rate', fontsize=13)
plt.ylabel('True Positive Rate', fontsize=13)
plt.grid(b=True, ls=':')
plt.legend(loc='lower right', fancybox=True, framealpha=0.8, fontsize=12)
plt.title(u'KNN (n_neighbors=9) ROC curve', fontsize=17)
plt.pause(3)
plt.savefig('../results/KNN-ROC.png', transparent=True)
print("saving images to ../results/KNN-ROC.png")
print("-" * 27)
plt.close()

# k-NN HSV Mask Histograms classfication report
KnnHSVMaskHis_repo = classification_report(testHMVL, model9.predict(testHMVI))
print("k-NN HSV Mask Histograms classfication report: ")
print(KnnHSVMaskHis_repo)
print("-" * 27)


# SVM
print("Model fitting with SVM")
print("[INFO] evaluating HLS hisograms after masking accuracy...")
tic = time.time()

modelsvc = SVC(kernel='rbf', gamma='auto', probability=True)
modelsvc.fit(trainHMVI, trainHMVL)
acc_train = modelsvc.score(trainHMVI, trainHMVL)
acc_test = modelsvc.score(testHMVI, testHMVL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] HSV hisograms after masking training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HSV hisograms after masking test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HSV hisograms after masking SVC classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))
print("SVC HSV Mask Histograms classfication report: ")
print(classification_report(testHMVL, modelsvc.predict(testHMVI)))
print("-" * 27)


# Random Forest HSV_hisogram after masking, default parameters
print("Model fitting with Random Forest")
print("[INFO] evaluating HSV hisograms after masking accuracy...")
tic = time.time()

rf0 = RandomForestClassifier(n_estimators=100, oob_score=True, random_state=27)
rf0.fit(trainHMVI, trainHMVL)
acc_train = rf0.score(trainHMVI, trainHMVL)
acc_test = rf0.score(testHMVI, testHMVL)

toc = time.time()
time_elapsed = toc - tic

print ("[INFO] his_mask_HSV histogram oob_scor: {:.2f}%".format(rf0.oob_score_* 100))
print("[INFO] HSV hisograms after masking training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HSV hisograms after masking test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HSV hisograms after masking RF classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))

# AUC
y_predprob = rf0.predict_proba(testHMVI)
print ("[INFO] AUC Score(test): %f" % metrics.roc_auc_score(testHMVL_onehot, y_predprob))
print("-" * 27)

# # gridsearch for the n_estimators
# print("Gridsearch for Random Forest hyperparameters")
# param_test1 = {'n_estimators':range(50,200,10)}
# gsearch1 = GridSearchCV(estimator = RandomForestClassifier(oob_score=True,random_state=27), 
#                        param_grid = param_test1, scoring='roc_auc',cv=5)
# gsearch1.fit(testHMVI, testHMVL_onehot)
# print ("[INFO] gsearch1.best_params_: {}, gsearch1.best_score_: {}".format(gsearch1.best_params_, gsearch1.best_score_))

# # gridsearch for max_depth & min_samples_split
# param_test2 = {'max_depth':range(3,14,2), 'min_samples_split':range(2,10,2)}
# gsearch2 = GridSearchCV(estimator = RandomForestClassifier(n_estimators= 190,oob_score=True, random_state=27),
#    param_grid = param_test2, scoring='roc_auc', cv=5)
# gsearch2.fit(testHMVI, testHMVL_onehot)
# print ("[INFO] gsearch2.best_params_: {}, gsearch2.best_score_: {}".format(gsearch2.best_params_, gsearch2.best_score_))

# # gridsearch for min_samples_split & min_samples_leaf
# param_test3 = {'min_samples_split':range(2,10,2), 'min_samples_leaf':range(2,10,2)}
# gsearch3 = GridSearchCV(estimator = RandomForestClassifier(n_estimators= 190, max_depth=13, oob_score=True, random_state=27),
#    param_grid = param_test3, scoring='roc_auc', cv=5)
# gsearch3.fit(testHMVI, testHMVL_onehot)
# print ("[INFO] gsearch3.best_params_: {}, gsearch3.best_score_: {}".format(gsearch3.best_params_, gsearch3.best_score_))

# # gridsearch for max_features
# param_test4 = {'max_features':range(3,60,2)}
# gsearch4 = GridSearchCV(estimator = RandomForestClassifier(n_estimators= 190, max_depth=13, min_samples_split=2,
#                                   min_samples_leaf=2 ,oob_score=True, random_state=27),
#    param_grid = param_test4, scoring='roc_auc',iid=False, cv=5)
# gsearch4.fit(testHMVI, testHMVL_onehot)
# print ("[INFO] gsearch4.best_params_: {}, gsearch4.best_score_: {}".format(gsearch4.best_params_, gsearch4.best_score_))

# random forest HSV_hisogram after masking, gridsearch parameters
print("[INFO] Reset parameters and evaluating HLS hisograms after masking accuracy...")
tic = time.time()

rf1 = RandomForestClassifier(n_estimators= 180, max_depth=5, min_samples_split=2,
                                  min_samples_leaf=2, max_features=7, oob_score=True, random_state=27)
rf1.fit(trainHMVI, trainHMVL)
acc_train = rf1.score(trainHMVI, trainHMVL)
acc_test = rf1.score(testHMVI, testHMVL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] his_mask_HSV histogram oob_scor: {:.2f}%".format(rf1.oob_score_* 100))
print("[INFO] HSV hisograms after masking training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HSV hisograms after masking test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HSV hisograms after masking RF classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))

y_predprob = rf1.predict_proba(testHMVI)
print ("AUC Score (test): %f" % metrics.roc_auc_score(testHMVL_onehot, y_predprob))
print("-" * 27)

# feels like after the gridsearch it does't get better results
# compare to the first RF model, so report the first model
print("Random Forest HSV Mask Histograms classfication report: ")
print(classification_report(testHMVL, rf0.predict(testHMVI)))
print("-" * 27)


# XGBoost
print("Model fitting with XGBoost")
params = {'learning_rate': 0.1, 'n_estimators': 500, 'max_depth': 5, 'min_child_weight': 1, 'seed': 0,
                'subsample': 0.8, 'colsample_bytree': 0.8, 'gamma': 0, 'reg_alpha': 0, 'reg_lambda': 1}
                                    
print("[INFO] evaluating HSV hisograms after masking accuracy...")
tic = time.time()

modelxgb = XGBClassifier(**params)
modelxgb.fit(trainHMVI, trainHMVL)
acc_train = modelxgb.score(trainHMVI, trainHMVL)
acc_test = modelxgb.score(testHMVI, testHMVL)

toc = time.time()
time_elapsed = toc - tic

print("[INFO] HSV hisograms after masking training set accuracy: {:.2f}%".format(acc_train * 100))
print("[INFO] HSV hisograms after masking test set accuracy: {:.2f}%".format(acc_test * 100))
print("[INFO] HSV hisograms after masking RF classifier complete in {:.0f}m {:.0f}s".format(
    time_elapsed // 60, time_elapsed % 60))
print("XGBoost HSV Mask Histograms classfication report: ")
print(classification_report(testHMVL, modelxgb.predict(testHMVI)))
print("-" * 27)


# Plot all the ROC curve
# SVC prediction probability of each class
y_scoresvc = modelsvc.predict_proba(testHMVI)
fprsvc, tprsvc, thresholds = metrics.roc_curve(testHMVL_onehot.ravel(),y_scoresvc.ravel())
aucsvc = metrics.auc(fprsvc, tprsvc)

# XGB prediction probability of each class
y_scorexgb = modelxgb.predict_proba(testHMVI)
fprxgb, tprxgb, thresholds = metrics.roc_curve(testHMVL_onehot.ravel(),y_scorexgb.ravel())
aucxgb = metrics.auc(fprxgb, tprxgb)

# RF prediction probability of each class
y_scorerf0 = rf0.predict_proba(testHMVI)
fprrf0, tprrf0, thresholds = metrics.roc_curve(testHMVL_onehot.ravel(),y_scorerf0.ravel())
aucrf0 = metrics.auc(fprrf0, tprrf0)

plt.plot(fprknn9, tprknn9, c = 'b', lw = 2, linestyle='-.', alpha = 0.7, label = u'knnAUC=%.3f' % aucknn9)
plt.plot(fprrf0, tprrf0, c = 'g', lw = 2, linestyle='--', alpha = 0.7, label = u'rfAUC=%.3f' % aucrf0)
plt.plot(fprxgb, tprxgb, c = 'r', lw = 2, linestyle=':', alpha = 0.7, label = u'xgbAUC=%.3f' % aucxgb)
plt.plot(fprsvc, tprsvc, c = 'y', lw = 2, linestyle='-', alpha = 0.7, label = u'svcAUC=%.3f' % aucsvc)
plt.plot((0, 1), (0, 1), c = '#808080', lw = 1, ls = '--', alpha = 0.7)

plt.xlim((-0.01, 1.02))
plt.ylim((-0.01, 1.02))
plt.xticks(np.arange(0, 1.1, 0.1))
plt.yticks(np.arange(0, 1.1, 0.1))
plt.xlabel('False Positive Rate', fontsize=13)
plt.ylabel('True Positive Rate', fontsize=13)
plt.grid(b=True, ls=':')
plt.legend(loc='lower right', fancybox=True, framealpha=0.8, fontsize=12)
plt.title(u'ROC Curve', fontsize=17)
plt.pause(3)
plt.savefig('../results/All-ROC.png', transparent=True)
print("saving images to ../results/All-ROC.png")
plt.close()
print("-" * 27)

totaltime = time.time() - start
print("Script complete in {:.0f}m {:.0f}s".format(totaltime // 60, totaltime % 60))