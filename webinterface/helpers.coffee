class PresetManager
    constructor: -> 
        raw =  localStorage["presets"] || "{}"
        @dta = JSON.parse raw
    list: -> @dta
    get: (key) -> @dta[key] || {}
    set: (key, val) ->
        @dta[key] = val
        localStorage["presets"] = JSON.stringify @dta
@PresetManager = PresetManager


@rgb2css = (r, g, b) ->
    c2h = (val) ->
        str = val.toString 16
        str = '0' + str if str.length == 1
        str
    '#' + c2h(r) + c2h(g) + c2h(b)


@printRoom = (roomname)->
    console.log "printing " + roomname
    outer_deferred = Q.defer()
    client.get_devices roomname, (devices)->
        promises = []
        devices.forEach (devname)-> 
            inner_deferred = Q.defer()
            client.get_devicestatus roomname, devname, (data)->
                console.log "dta"
                inner_deferred.resolve [devname, data]
            promises.push inner_deferred.promise
        console.log promises
        Q.allResolved(promises)
        .then (promises)->
            console.log "complete " + roomname
            rcon = $ '<div>'
            rcon.append roomname
            button = $ "<button> request control </button>"
            button.click -> 
                client.get_control roomname
                undefined
            rcon.append button
            rcon.append '<br>'
            $('#container').append rcon
            # console.log promises
            promises.forEach (promise)->
                console.log "it it it"
                if not promise.isFulfilled()
                    console.log "oO excetion: ", promise.valueOf().exception
                    throw promise.valueOf().exception
                @sta = status = promise.valueOf()
                # return
                console.log status
                color = status[1]
                console.log "\t %s: rgb(%s, %s, %s)", status[0], color.r, color.g, color.b
                form = $ '<input type="color">'
                form.change ->
                    cols = form.val().match '#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})'
                    console.log cols
                    client.change_device roomname, status[0],  {
                                                            r: parseInt cols[1], 16
                                                            g: parseInt cols[2], 16
                                                            b: parseInt cols[3], 16 }
                    undefined
                form.val rgb2css color.r, color.g, color.b
                rcon.append form
                rcon.append status[0]
                rcon.append '<br>'
                celems[roomname + "|||" + status[0]] = form
                undefined
            undefined
        .then( (-> outer_deferred.resolve()), ((e)-> @a||=[];@a.push(e))) 
    return outer_deferred.promise

 



#                 if (promise.isFulfilled()) {
#                     var status = promise.valueOf();
#                     var color = status[1];
#                     console.log("\t %s: rgb(%s, %s, %s)", status[0], color.r, color.g, color.b);
#                     var form = $('<input type="color" class="col"/>');
#                     form.val(rgb2css(color.r, color.g, color.b));
#                     form.change(function(){
#                         console.log('color changed ' + form.val());
#                         var cols = form.val().match('#([0-9a-f]{2})([0-9a-f]{2})([0-9a-f]{2})');
#                         client.change_device(roomname, status[0], { r:parseInt(cols[1], 16),
#                                                                     g:parseInt(cols[2], 16),
#                                                                     b:parseInt(cols[3], 16) })
#                     });
#                     rcon.append(form);
#                     rcon.append(status[0]);
#                     rcon.append('<br>');
#                     celems[roomname + "|||" + status[0]]=form;
#                 } else {
#                     throw promise.valueOf().exception;
#                 }
#             });
#         })
#         .then(function(){deferred.resolve()});
#     })
#     return deferred.promise;
# };






# var printRoom = function(roomname){
#     var deferred = Q.defer();
#     client.get_devices(roomname, function(devices){
#         var promises = [];
#         devices.forEach(function(devname){
#             var deferred = Q.defer();
#             client.get_devicestatus(roomname, devname, function(data){
#                 deferred.resolve([devname, data]);
#             })
#             promises.push(deferred.promise);
#         });
#         Q.allResolved(promises)
#         .then(function (promises) {
#             console.log("%s:", roomname);
#             var rcon = $('<div>');
#             rcon.append(roomname);
#             var button = $("<button>request controll</button>");
#             button.click(function(){
#                 client.get_control(roomname);
#             });
#             rcon.append(button)
#             rcon.append('<br>');
#             $("#container").append(rcon)
#             promises.forEach(function(promise) {