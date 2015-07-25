@Groups = new Meteor.Collection 'data.groups'

@ChatMessage = new Meteor.Collection 'data.ChatMessage'
Partitioner.partitionCollection ChatMessage, {index: {ts: 1}}

@ChatRoom = new Meteor.Collection 'data.ChatRoom'

if not Groups.findOne('name': 'Warriors')?
	# Groups
	warrior = Groups.insert
		name: 'Warriors'
		ts: new Date

	cavalier = Groups.insert
		name: 'Cavaliers'
		ts: new Date

	# Warriors Group Users
	scurry = Meteor.users.insert
		username: 'scurry'
		emails: [ {
			address: 'scurry@warriors.com'
			verified: true
		} ]
		createdAt: new Date
		avatarOrigin: 'none'
		_groupId: warrior

	Accounts.setPassword scurry, 'password'

	kthompson = Meteor.users.insert
		username: 'kthompson'
		emails: [ {
			address: 'kthompson@warriors.com'
			verified: true
		} ]
		profile: name: 'Klay Thompson'
		createdAt: new Date
		avatarOrigin: 'none'
		_groupId: warrior

	Accounts.setPassword kthompson, 'password'

	# Cavaliers Group Users
	ljames = Meteor.users.insert
		username: 'ljames'
		emails: [ {
			address: 'ljames@cavaliers.com'
			verified: true
		} ]
		profile: name: 'Lebron James'
		createdAt: new Date
		avatarOrigin: 'none'
		_groupId: cavalier

	Accounts.setPassword ljames, 'password'

	kirving = Meteor.users.insert
		username: 'kirving'
		emails: [ {
			address: 'kirving@cavaliers.com'
			verified: true
		} ]
		profile: name: 'Kyrie Irving'
		createdAt: new Date
		avatarOrigin: 'none'
		_groupId: cavalier

	Accounts.setPassword kirving, 'password'

	# Warriors Chat Rooms
	ChatRoom.insert
		usernames: [
			'scurry'
			'kthompson'
		]
		ts: new Date
		t: 'c'
		name: 'athletes'
		msgs: 0
		_groupId: warrior

	ChatRoom.insert
		usernames: [
			'scurry'
			'kthompson'
		]
		ts: new Date
		t: 'c'
		name: 'gameplan'
		msgs: 0
		_groupId: warrior

	# Cavaliers Chat Rooms
	ChatRoom.insert
		usernames: [
			'ljames'
			'kirving'
		]
		ts: new Date
		t: 'c'
		name: 'coaches'
		msgs: 0
		_groupId: cavalier

	ChatRoom.insert
		usernames: [
			'ljames'
			'kirving'
		]
		ts: new Date
		t: 'c'
		name: 'stars'
		msgs: 0
		_groupId: cavalier


Partitioner.partitionCollection ChatRoom, {index: {ts: 1}}

@ChatSubscription = new Meteor.Collection 'rocketchat_subscription'
Partitioner.partitionCollection ChatSubscription, {index: {ts: 1}}

@ChatTyping = new Meteor.Collection 'data.ChatTyping'
Partitioner.partitionCollection ChatTyping, {index: {ts: 1}}

