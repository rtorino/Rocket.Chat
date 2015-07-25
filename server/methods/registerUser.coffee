Meteor.methods
	registerUser: (formData) ->
		userData =
			email: formData.email
			password: formData.pass

		userId = Accounts.createUser userData

		Meteor.users.update userId,
			$set:
				name: formData.name
				_groupId: formData.group

		if userData.email
			Accounts.sendVerificationEmail(userId, userData.email);
