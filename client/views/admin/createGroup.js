Meteor.subscribe('groups')

Template.admin.events({
	'submit #create-group': function(event, template) {
		event.preventDefault();

		var groupName = $(event.target).find('input[name=groupName]').val();
		Meteor.call('groups.create', groupName, function(error, results) {
			if (error) {
				console.log(error.reason);
			} else {
				$(event.target).find('input[name=groupName]').val('');
			}
		});
	}
});

Template.admin.helpers({
	'groups': function() {
		return Groups.find({});
	}
});

Template.admin.onRendered(function() {
	Meteor.defer(function() {
		$('input[name=groupName]').select().focus();
	});
});
