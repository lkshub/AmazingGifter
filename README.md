# AmazingGifters
Group members: Chong Wu Guo, Kai Lu, Tongzhe Zhang, Jiaohao Luo

Kai and Chong are responsible for the iOS part.

Project Video @ [Youtube](https://www.youtube.com/watch?v=7hj5-vhBFlY)

## 1. The problem we are solving

People usually prefer a favorable fancy gift to dull and ordinary gifts from their friends. However, the fancy gifts are often too expensive for a single person to afford. Furthermore, it is inconvenient for a person to share his/her desirable gifts to their friends.

## 2. Use cases

In the first case, when some Holidays are coming, people would expect to receive some gifts from their friends. However, the gift we received are usually not very favorable and desirable.  By using our application, on the other hand, the users could add their favorite gifts to wish list, and give their friends hints of what they adore by sharing the gift to their timelines on Facebook. 

In the second case, people want to send their friends some fancy gifts. However, these gifts are usually too expensive for them to afford individually. By using our application, they could add a crowdfunding gift for their friends or just join the gift event initiated by others. They could share the gift to their timeline on Facebook to let more friends join this gift crowdfunding.

## 3. Who are our target users/customers and why they want to use our app

Gift receiver will use our app, they want to get some exquisite gifts for their birthday or other reasons. There are some reasons why they use our app. First, they can’t afford it by themselves; similarly, their friends cannot afford it individually without collaboration; On the other hand, the app provides the channel for users to express their interests and favorite gifts of what they want, so their friends no longer need to spend time on gift decision making.

Gift giver will use our app, they want to give some gifts to their friends for their birthday or other reasons. There are some reasons why they use our app. First, they can not afford a exquisite gift by themselves; Second, they don’t know what their friend exactly wants; Third,  it is a comfortable way to get the information that what their friends like; fourthly,it is an easy way to make both of them satisfied.
 
Electronic commerce company, such as Ebay, may want to cooperate with our app, and they are the source of our revenue. There are several reasons for why. First, all the gifts would be searched, picked and purchased exclusively from the electronic commerce platform we provide( that’s eBay here), so that we could bring flow and profit to eBay. Second, the crowdfunding idea would encourage people to do more purchases, which would bring superior profit to the platform. Third, we can improve the brand effect of the platform.

![Figure 1: The business Model Canvas of AmazingGifter](https://firebasestorage.googleapis.com/v0/b/amazinggifter-prealpha.appspot.com/o/BMC%20Of%20Gift.jpg?alt=media&token=b34ed34a-f749-492d-b39d-99e89a558aae)
Figure 1 The business Model Canvas of AmazingGifter 

## 4. Uniqueness of our approach

Comparing to other wish listing approaches, our app focuses more on crowdfunding. Users are not limited to the degree of their contributions, they can contribute to the extent that they can afford or they are willing to. 

The other distinction about our app is the social network integration. We integrated facebook into our app and users are required to log in with their facebook account to use the app, therefore users can directly interact with their facebook friends. Users can also share their wish list to facebook and the app has the ability to notify the progress of a crowdfunding. These social emphasis features can increase users’ enthusiasm and thus improve the success rate of gift crowdfunding.

## 5. Implementation Overall Architecture

Our project’s overall architecture can be explained explicitly according to the following figure. Speaking generally, the architecture consists of three technical parts.

![](https://firebasestorage.googleapis.com/v0/b/amazinggifter-prealpha.appspot.com/o/Copy%20of%20Application%20architecture.png?alt=media&token=3e4df01f-0f4e-4938-8052-be2026b4bd35)
Figure 2 Project Architecture

1.As to frontend part, it includes two major mainstream mobile phone platforms which are native Android and iOS. Those two frequently-used platforms cover most of the mobile application users which can help our business establish a wide range of user groups.

2.Since the core value of our project can be simply concluded as “gift crowdfunding”, our API implementation includes eBay API, PayPal system and Facebook SDK. 

At the very early stage of the project, we decided to choose facebook as our only user login method, because facebook has a large number of users which can help us save time to explore our users and share our application base on facebook’s social network. By using Facebook SDK, the application can fetch user’s basic information and share their initiating gift crowdfunding to their friends. Besides, as a gift crowdfunding application, its usage rate may be limited. People may use this application based on certain condition only, such as birthday, upcoming festivals etc. There is no need to establish our own login system for now. 

In addition, gift is another important component. Amazon is our first choice as gift product searching source. However, it has certain condition that we are not qualified currently which make us pivot to another large product trading online platform, ebay. As a lthough ebay may not be as regulatory as Amazon, it can also provide users a great gift searching result. Amazon and other electronic commerce platforms will be considered in the future plan. 

PayPal is selected as our payment system. Because it is a fast and safe way to pay online without sharing financial details. Besides, PayPal comes very naturally since we are using ebay as our gift platform. (We first think about using Venmo APIs since it allows users transfer their money to other users without any service fee, but unfortunately Venmo stop granting any API permissions to new developers since February 2016.)

3.The last part is our backend, Firebase. Firebase not only serves as database in our project, it also integrates several other services like, for example, the user authentication service with facebook login. Firebase database is a NoSQL database, the data are stored as JSON file and we can save and retrieve the real-time datas through RESTful API. 

## 6. Implementation Status

As the overall architecture mentioned above, we have been implemented most of the features to both frontend platform. Both Android and iOS platforms work fine with Facebook login, Ebay searching API and Firebase backend. However, as to payment system, we are still looking for a more suitable payment system that can help us complete the crowdfunding payment. Currently, the PayPal system we’ve been integrated to our application in both platform is just a pseudo-payment-system, which means no real money will be manipulated.

## 7. External Services

Firebase: for database and user authentication

Facebook: for user profile, social connection and sharing gifts to timeline

eBay: for gift resources

Paypal: for the purchase transactions


## 8. Development status in the second platform

Basically, the development statuses of both platforms are identical, both our platforms have achieved most of the features that we mentioned above, such as Facebook login, Ebay searching API, Firebase RESTful API interaction. Specific implementation status has been explained in the previous paragraph.  

## 9. Next steps for the project, the plan and status of the efforts to deploy the app

### 1. Future works
Recruit more Alpha testers and collect their feedbacks for our application’s further improvement.
Join the eBay Partner Network.
Refine our App design to a Beta version.
Extend our gift product data sources by importing more electronic commerce platforms  such as Amazon, Bestbuy and Newegg.
Publish our App both on Apple App Store and Google Play. 

### 2.  Deployment status
Since our server is run on Firebase, there is no extra server deployment process required. We will try to list our app on Apple App Store and Google Play after further polishment.
