@ChatMessages = (->
	self = {}
	wrapper = {}
	input = {}
	editing = {}
	selfTyping = new ReactiveVar false
	typingTimeout = {}

	init = ->
		wrapper = $(".messages-container").find(".wrapper")
		input = $(".input-message").get(0)
		# self.scrollable = false
		# wrapper.bind "scroll", ->
			# scrollable()
		bindEvents()
		return

	# isScrollable = ->
	# 	self.scrollable

	resize = ->
		dif = 60 + $(".messages-container").find("footer").outerHeight()
		$(".messages-box").css
			height: "calc(100% - #{dif}px)"

	# scrollable = ->
		# wrapper = $(".messages-container").find(".wrapper")
		# top = wrapper.scrollTop() + wrapper.outerHeight()
		# if top == wrapper.get(0).scrollHeight
		# 	self.scrollable = true
		# else
		# 	self.scrollable = false

	toPrevMessage = ->
		msgs = wrapper.get(0).querySelectorAll(".own:not(.system)")
		if msgs.length
			if editing.element
				if msgs[editing.index - 1]
					edit msgs[editing.index - 1], editing.index - 1
			else
				edit msgs[msgs.length - 1], msgs.length - 1

	toNextMessage = ->
		if editing.element
			msgs = wrapper.get(0).querySelectorAll(".own:not(.system)")
			if msgs[editing.index + 1]
				edit msgs[editing.index + 1], editing.index + 1
			else
				clearEditing()

	getEditingIndex = (element) ->
		msgs = wrapper.get(0).querySelectorAll(".own:not(.system)")
		index = 0
		for msg in msgs
			if msg is element
				return index
			index++
		return -1

	edit = (element, index) ->
		return if element.classList.contains("system")
		clearEditing()
		id = element.getAttribute("id")
		message = ChatMessage.findOne { _id: id, 'u._id': Meteor.userId() }
		input.value = message.msg
		editing.element = element
		editing.index = index or getEditingIndex(element)
		editing.id = id
		element.classList.add("editing")
		input.classList.add("editing")
		setTimeout ->
			input.focus()
		, 5

	clearEditing = ->
		if editing.element
			editing.element.classList.remove("editing")
			input.classList.remove("editing")
			editing.id = null
			editing.element = null
			editing.index = null
			input.value = editing.saved or ""
		else
			editing.saved = input.value

	# toBottom = ->
	# 	ScrollListener.toBottom()

	send = (rid, input) ->
		if _.trim(input.value) isnt ''
			KonchatNotification.removeRoomNotification(rid)
			msg = input.value
			input.value = ''
			stopTyping(rid)
			Meteor.call 'sendMessage', { rid: rid, msg: msg, day: window.day }

	deleteMsg = (element) ->
			id = element.getAttribute("id")
			Meteor.call 'deleteMessage', { id: id }, (error, result) ->
				if error
					return Errors.throw error.reason

	update = (id, rid, input) ->
		if _.trim(input.value) isnt ''
			msg = input.value
			Meteor.call 'updateMessage', { id: id, msg: msg }
			clearEditing()
			stopTyping(rid)

	startTyping = (rid, input) ->
		if _.trim(input.value) isnt ''
			unless typingTimeout?[rid]
				if Meteor.userId()?
					selfTyping.set true
					Meteor.call 'typingStatus', rid, true
				typingTimeout[rid] = Meteor.setTimeout ->
					stopTyping(rid)
				, 10000
		else
			stopTyping(rid)

	stopTyping = (rid) ->
		selfTyping.set false
		if typingTimeout?[rid]?
			clearTimeout(typingTimeout[rid]) 
			typingTimeout[rid] = null

		Meteor.call 'typingStatus', rid, false

	bindEvents = ->
		if wrapper?.length
			$(".input-message").autogrow
				postGrowCallback: ->
					resize()
					# toBottom() if self.scrollable

	keyup = (rid, event) ->
		input = event.currentTarget
		k = event.which
		keyCodes = [
			13, # Enter
			20, # Caps lock
			16, # Shift
			9,  # Tab
			27, # Escape Key
			17, # Control Key
			91, # Windows Command Key
			19, # Pause Break
			18, # Alt Key
			93, # Right Click Point Key
			45, # Insert Key
			34, # Page Down
			35, # Page Up
			144, # Num Lock
			145 # Scroll Lock
		]
		keyCodes.push i for i in [35..40] # Home, End, Arrow Keys
		keyCodes.push i for i in [112..123] # F1 - F12

		unless k in keyCodes
			startTyping(rid, input)

	keydown = (rid, event) ->
		input = event.currentTarget
		k = event.which
		resize(input)
		if k is 13 and not event.shiftKey
			event.preventDefault()
			event.stopPropagation()
			if editing.id
				update(editing.id, rid, input)
			else
				send(rid, input)
			return
		if k is 27
			if editing.id
				event.preventDefault()
				event.stopPropagation()
				clearEditing()
				return
		else if k is 38 or k is 40 # Arrow Up or down
			if k is 38
				return if input.value.slice(0, input.selectionStart).match(/[\n]/) isnt null
				toPrevMessage()
			else
				return if input.value.slice(input.selectionEnd, input.value.length).match(/[\n]/) isnt null
				toNextMessage()

			event.preventDefault()
			event.stopPropagation()

	# isScrollable: isScrollable
	# toBottom: toBottom
	keydown: keydown
	keyup: keyup
	deleteMsg: deleteMsg
	send: send
	init: init
	edit: edit
	selfTyping: selfTyping
)()
