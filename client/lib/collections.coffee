@UserAndRoom = new Meteor.Collection null
@ChatMessageHistory = new Meteor.Collection null

@ChatRoom = new Meteor.Collection 'data.ChatRoom'
Partitioner.partitionCollection ChatRoom, {index: {ts: 1}}

@ChatSubscription = new Meteor.Collection 'data.ChatSubscription'
Partitioner.partitionCollection ChatSubscription, {index: {ts: 1}}

@ChatMessage = new Meteor.Collection 'data.ChatMessage'
Partitioner.partitionCollection ChatMessage, {index: {ts: 1}}

@ChatTyping = new Meteor.Collection 'data.ChatTyping'
Partitioner.partitionCollection ChatTyping, {index: {ts: 1}}

@Groups = new Meteor.Collection 'data.groups'

Meteor.startup ->
	ChatMessage.find().observe
		added: (record) ->
			if ChatRoom._collection._docs._map[record.rid]? and not ChatMessageHistory._collection._docs._map[record._id]?
				ChatMessageHistory.insert record

		changed: (record) ->
			_id = record._id
			delete record._id

			ChatMessageHistory.update { _id: _id }, { $set: record }

		removed: (record) ->
			ChatMessageHistory.remove {_id: record._id}
