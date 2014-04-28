@helpers = @helpers || {}

@helpers.click = (element) ->
	if document.createEvent
		evt = document.createEvent 'MouseEvent'
		evt.initMouseEvent('click', true, true, window, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, null)

		element.dispatchEvent(evt);
	else
		evt = document.createEventObject
		element.fireEvent('on'+event,evt)
