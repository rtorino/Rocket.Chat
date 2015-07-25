Meteor.methods({
	'groups.create': function (name) {
		check(name, String)

		return Groups.insert({
			name: name,
			ts: new Date()
		});
	}
});
