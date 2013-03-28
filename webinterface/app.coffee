@client = new Client('http://localhost:8012')
@presman = new PresetManager()
@celems = {}

client.on 'ready', ->
    Q.fcall ->
        deferred = Q.defer()
        client.sync_all ->
            deferred.resolve()
            console.log "synced"
        deferred.promise
    .then ->
        deferred = Q.defer()
        client.get_rooms (rooms)->
            deferred.resolve rooms
        deferred.promise
    .then (rooms)->
        promises = []
        console.log rooms
        for room in rooms
            console.log room
            promises.push printRoom(room)
        Q.all promises
    .done ->
        $('#container').append('<hr>').append('<hr>')
        console.log 'end of room list'
        presetfoo()