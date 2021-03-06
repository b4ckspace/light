drawform = ->
    namefield = $('<input type="text"/>')
    button = $("<button>save status</button>")
    $("#container").append(namefield).append(button).append("<br/>")
    button.click ->
        name = namefield.val()
        return alert "presetname needed!" if !name
        console.log "save preset name " + name
        dta = {}
        for devname of celems
            console.log devname, celems[devname].val()
            dta[devname] = celems[devname].val()
        presman.set name, dta
        drawpreset name


drawpresets = ->
    for presetname of presman.list()
        drawpreset presetname


drawpreset = (presetname)->
    el = $('<a href="#">'+presetname+'</a>')
    $("#container").append el
    $("#container").append "<br/>"
    el.click ->
        console.log "set preset " + presetname
        preset = presman.get presetname
        for devname, color of preset
            celems[devname].val(color).change()


@presetfoo = ->
    drawform()
    drawpresets()