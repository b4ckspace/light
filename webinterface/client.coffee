api_functions = [   "get_rooms", "get_devices", "get_devicestatus",
                    "change_device", "change_some", "change_all", "change_room",
                    "sync_all", "set_priority",
                    "has_control", "get_control", "can_get_control", "release_control"]
class Client
    constructor: (url)->
        EventEmitter.call @
        @socket = io.connect url
        @socket.on 'connect', =>
            @emit 'ready'
inherits Client, EventEmitter

# create a function for each apicall
for funname in api_functions
    ((funname)->
        Client.prototype[funname] = ->
            args = Array.prototype.slice.apply arguments, [0]
            
            #if a callback is given, wrap it for error checking
            cb = args[args.length-1]
            if typeof(cb)=='function'
                args[args.length-1] = (response) =>
                    if response.ok
                        cb response.data
                    else
                        @emit 'error', funname, response.error
            #add the api call name to the request
            args.unshift funname

            #apicall
            @socket.emit.apply @socket, args
    )(funname)
@Client = Client