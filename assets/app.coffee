##= require ./action_cable
##= require_self

@Chat ||= {}
@Chat.cable = ActionCable.createConsumer("ws://#{window.location.host}/ws")

class InputListener
    constructor: (selector, @callback) ->
        @el = document.querySelector(selector)
        @input  = @el.querySelector("input")
        @button = @el.querySelector("button")
        @input.addEventListener('keyup', @onKey)
        @button.addEventListener('click', @onClick)
    stop: ->
        @input.removeEventListener('keyup', @onKey)
        @button.removeEventListener('click', @onClick)
    call: ->
        @callback(@input.value)
        @input.value = ''
    onKey:   (ev) => @call() if ev.keyCode is 13
    onClick: (ev) => @call()
    focus: -> @input.focus()


@Chat.cable.subscriptions.create "ChatChannel",

    received: (data) ->
        # Called when there's incoming data on the websocket for this channel
        message = document.createElement('div')
        message.innerHTML =
            "<span>#{data.user}</span><span>#{data.message}</span>"
        @messages.appendChild(message)

    # Called when the subscription is ready for use on the server
    connected: ->
        @messages = document.querySelector('.messages')
        document.body.className = "ask-name"
        @nameListener = new InputListener '.whoami', @setName.bind(@)

    setName: (name) ->
        document.body.className = "chatting"
        @perform("set_name", {name})
        @msgListener = new InputListener '.deliver', @sendMessage.bind(@)
        @msgListener.focus()

    sendMessage: (message) ->
        @perform("send_message", {message})

    # Called when the WebSocket connection is closed
    disconnected: ->
        document.body.className = "pending"
        @nameListener.stop()
        delete @nameListener
        @msgListener?.stop()
        delete @msgListener
