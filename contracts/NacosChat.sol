// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

contract NacosChat {

    struct User {
        address wallet;
        string name;
        uint [] userTweets;
        address[] following;
        address[] followers;

        mapping (address => Message[]) conversations;
    }

    struct Message {
        uint messageId;
        string content;
        address from;
        address to;

    }

    struct Tweet {
        uint tweetId;
        address author;
        string content;
        uint createdAt;
    }

    mapping (address => User) public users; //to track users who register...abi

    mapping (uint => Tweet ) public tweets; //to track tweets as they come in, tweet1, tweet2

    uint256 public nextTweetId; //to track the Ids to make it available, in case someone else wanna tweet, so we creat a state variable

    uint public nextMessageId;

    function registerAccount(string memory _name) external {
        //we need to sanity check to ensure the person isn't leaving out an empty string. we typecast the string and convert it to byte.
        bytes memory bname = bytes(_name);
        
        require (bname.length != 0, "Name cannot be an empty string");

        User storage newUser = users[msg.sender];
        newUser.wallet = msg.sender;
        newUser.name = _name;

    }

    modifier accountExist(address _user){
        User storage thisUser = users[_user];

        bytes memory thisUserBytestr = bytes (thisUser.name);

        require(thisUserBytestr.length !=0, "This wallet does not belong to anyone");
        _;
    }

    function postTweet(string memory _content) external accountExist(msg.sender) {
        Tweet memory newTweet = Tweet(nextTweetId, msg.sender, _content, block.timestamp);

        tweets[nextTweetId] = newTweet;

        User storage thisUser = users[msg.sender];


        thisUser.userTweets.push(nextTweetId);
        nextTweetId++;
    }

    function readTweet (address _user) external view returns (Tweet[] memory) {
        uint[] storage userTweetsIds = users[_user].userTweets;

        Tweet[] memory userTweets =  new Tweet[](userTweetsIds.length); //recall Tweet is a struct...

        for (uint i=0; i < userTweetsIds.length; i++ ) {
            userTweets[i] = tweets[userTweetsIds[i]];
        }

        return userTweets;
    }

    function followUser(address _user) external accountExist(_user) accountExist(msg.sender){

        User storage functionCaller = users[msg.sender];
        functionCaller.following.push(_user);

        User storage user = users[_user];
        user.followers.push(msg.sender);
    }

    function getFollowing() external view accountExist(msg.sender) returns (address[] memory){
        return users[msg.sender].following;
    }

    function getFollowers() external view accountExist(msg.sender) returns (address[] memory) {
        return users[msg.sender].followers;
    }

    function sendMessage(address _recipient, string memory _content) external accountExist(msg.sender) accountExist(_recipient) {
        Message memory newMessage = Message(nextMessageId, _content, msg.sender, _recipient); //we just instantiate our struct 

        User storage sender = users[msg.sender];
        sender.conversations[_recipient].push(newMessage);

        User storage recipient = users[_recipient];
        recipient.conversations[msg.sender].push(newMessage);

        nextMessageId++;    
    }

    function getConversationWithUsers(address _user) external view returns (Message[] memory){
        User storage thisUser = users[msg.sender];
        return thisUser.conversations[_user];
    }
}