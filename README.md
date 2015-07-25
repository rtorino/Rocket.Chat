![Rocket.Chat logo](https://rocket.chat/images/logo/logo-dark.svg?v2)

The Complete Open Source Chat Solution

## About
This version of Rocket.Chat has feature for partitioning users. Users are assigned to a group.

## Development

The ability to partition collections within Rocket.Chat is provided by the [meteor-partitioner](https://atmospherejs.com/mizzao/partitioner) package. By just adding this package, you will be able to partition any collections and assigned users to a group. 

### Changes made to Rocket.Chat
- Added `/admin` route for creating new groups and the corresponding template and collection to persist group data.
- Added feature for a user to select a group on registration.
- Partitioned `ChatMessage`, `ChatRoom`, `ChatSubscription` and `ChatTyping` collections.
- Set user group upon login. API is provided by meteor-partitioner.
- Seed database with data on application start up

### Suggestions
- Rocket.Chat code base is already huge but I din't notice any coding conventions embedded into the repository except for the `.editorconfig` which I also don't like the 8 tabs spacing. I don't know how to add linting rules for coffee script but with JavaScript we can use JSHint, ESLint and JSCS
- meteor-partitioner have known issues listed in its repository, hopefully they will be addressed and I will happy to contribute if needed.

### Not working features
- Newly added channels are not reflected on other users view unless you refresh or logout then login again. This can be investigated and fix.

### Development process
- To easily and continuously integrate new Rocket.Chat features, we need to fork it and add the official Rocket.Chat as a remote. Then, we can easily pull updates from remote. For meteor-partitioner, we just need to run `meteor update` if we need to pull latest updates of our application packages.

## Running the app
Assuming that you have set up your environment for developing and running meteor applications, just run the following:

1. `git clone https://github.com/rtorino/Rocket.Chat`
2. `cd RocketChat`
3. `meteor`

## Seed Data
#### Groups
- Warriors
- Cavaliers

#### Warriors (username / password)
- scurry@warriors.com / password
- kthompson@warriors.com / password

### Cavaliers (username / password)
- kirving@cavaliers.com / password
- ljames@cavaliers.com / password

### Warriors' Channel
- athletes
- gameplan

### Cavaliers' Channel
- coaches
- stars
- 
