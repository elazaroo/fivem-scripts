let selected = 0;
let banselect = 0;
$(function () {
    function display(bool) {
        if (bool) {
            $("#container").fadeIn(500);
            document.getElementById('banlistqq').innerHTML = '';
        } else {
            $("#container").fadeOut(500);
            $('#banlist').fadeOut(500);
            document.getElementById('banlistqq').innerHTML = '';

        }
    }

    $("#bansearch").keyup(function() {

        // Retrieve the input field text and reset the count to zero
        var filter = $(this).val(),
          count = 0;
  
        // Loop through the comment list
        $('tbody tr').each(function() {
          // If the list item does not contain the text phrase fade it out
          if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();  // MY CHANGE
  
            // Show the list item if the phrase matches and increase the count by 1
          } else {
            $(this).show(); // MY CHANGE
            count++;
          }
  
        });
  
      });
    $("#search").keyup(function() {

        // Retrieve the input field text and reset the count to zero
        var filter = $(this).val(),
          count = 0;
  
        // Loop through the comment list
        $('#playerlist div').each(function() {
          // If the list item does not contain the text phrase fade it out
          if ($(this).text().search(new RegExp(filter, "i")) < 0) {
            $(this).hide();  // MY CHANGE
  
            // Show the list item if the phrase matches and increase the count by 1
          } else {
            $(this).show(); // MY CHANGE
            count++;
          }
  
        });
  
      });

    display(false)
    window.addEventListener('message', function (event) {
        var item = event.data
        if (event.data.type == "open") {
            $('#playerlist').empty();
            for (let i in event.data.players) {
                let player = event.data.players[i];
                $('#playerlist').append(`<div class="player" id="player_` + player.id + `">
                <div class="id">ID: ` + player.id + `</div>
                <div class="hr"></div>
                <div class="playername">` + player.name + `</div>
                </div>`)
            }


            $(".player").click(function () {
                let id = $(this).attr('id').replace('player_', '');
                selected = parseInt(id);
                $('.kick').remove()
                $('.spec').remove() 
                $('.goto').remove() 
                $('.bring').remove()
                $('.freeze').remove() 
                $('.screenshot').remove() 
                $('.banqq').remove() 
                $.post('https://keko_adminmenu/main', JSON.stringify({
                    selected: selected,
                }));
                $(".player").removeClass('active');
                $(this).addClass('active');
                var ee = Math.floor(Math.random() * 1213213131313);
                $('.infobox').append(`
                <div class="kick" id="`+ selected +`"><p>Kickear</p></div>
                <div class="spec" id="`+ selected +`"><p>Spectear</p></div>
                <div class="goto" id="`+ selected +`"><p>Goto</p></div>
                <div class="bring" id="`+ selected +`"><p>Bring</p></div>
                <div class="freeze" id="`+ selected +`"><p>Congelar</p></div>
                <div class="screenshot" id="`+ selected +`"><p>Discord Screenshot</p></div>
                <div class="banqq" id="`+ selected +`"><p>Banear</p></div>
                `)
                $('#container').append(`<div class="loader" id='`+ ee +`'></div>`)
                $('.infobox').hide()
                $(".playerbox").addClass("disabled");
                $(".inventorybox").addClass("disabled");
                $('.clearinv').empty()

                $(".kick").click(function() {
                    console.log('test')
                    let grundaction = $("#grundaction").val()
                    if (grundaction.length < 1 || !grundaction) {
                        return
                    }
                    $.post('https://keko_adminmenu/action', JSON.stringify({
                        target: this.id,
                        da: 'kick',
                        grund: grundaction
                    }));
                    return;
                });

                $(".banqq").click(function() {
                    let grundaction = $("#grundaction").val()
                    if (grundaction.length < 1 || !grundaction) {
                        return
                    }
                    console.log(banselect)
                    $.post('https://keko_adminmenu/action', JSON.stringify({
                        target: this.id,
                        da: 'ban',
                        grund: grundaction,
                        time: banselect
                    }));
                    return;
                });

                $(".spec").click(function() {
                    $.post('https://keko_adminmenu/action', JSON.stringify({
                        target: this.id,
                        da: 'spec',
                        grund: 'none'
                    }));
                    return;
                });

                $(".goto").click(function() {
                    $.post('https://keko_adminmenu/action', JSON.stringify({
                        target: this.id,
                        da: 'goto',
                        grund: 'none'
                    }));
                    return;
                });

                
                $(".bring").click(function() {
                    $.post('https://keko_adminmenu/action', JSON.stringify({
                        target: this.id,
                        da: 'bring',
                        grund: 'none'
                    }));
                    return;
                });

                $(".freeze").click(function() {
                    $.post('https://keko_adminmenu/action', JSON.stringify({
                        target: this.id,
                        da: 'freeze',
                        grund: 'none'
                    }));
                    return;
                });

                $(".screenshot").click(function() {
                    $.post('https://keko_adminmenu/action', JSON.stringify({
                        target: this.id,
                        da: 'screenshot',
                        grund: 'none'
                    }));
                    return;
                });

                setTimeout(function(){ 
                        $('#' + ee).remove() 
                        $('.infobox').show()
                        $(".playerbox").removeClass("disabled");
                        $(".inventorybox").removeClass("disabled");
                }, 1500);
            });
        } else if (event.data.type == "banlistap") {
            if (event.data.perm === "yes") {
                var permimg = "https://i.imgur.com/AkhE0f7.png"
            } else {
                var permimg = "https://i.imgur.com/4wd5q1a.png"
            }

            $('#banlistqq').append(`
                    <tr id="banlistitem" class="banlistitem">
                        <td>1</td>
                        <td>` + event.data.name +`</td>
                        <td>` + event.data.reason +`</td>
                        <td>` + event.data.source +`</td>
                        <td>21.01.2021 19:42:32</td>
                        <td><img src=` + permimg +`  class="tableimg"></td>
                        <td ><img src="img/trash.png" license="` + event.data.license +`" class="tableimg1"  onclick="entbannen('`+event.data.license+`')"></td>
                    </tr>
            `)

        } else if (event.data.type == "refreshinfos") {
            $('#meingeld').text('$' + item.cash)
            $('#meinebank').text('$' + item.bankmoney)
            $('#meinschwarzgeld').text('$' + item.blackmoney)
            $('#realname').text(item.firstname + ' ' + item.lastname)
            $('#dob').text(item.dob)
            $('#height').text(item.height)
            $('#sex').text(item.sex)
        } else if (event.data.type == "playeritems") {
            $('.clearinv').append(`<div class="item">
            <div class="anzahl">` + item.amount + `</div>
            <div class="hr"></div>
            <div class="itemname">` + item.label +`</div>
            </div>`)
        }  else if (event.data.type == "invhr") {
            $('.clearinv').append(`<div class="item" style="background-color: grey;">
            <div class="anzahl"> INVENTARIO </div>
            <div class="hr"></div>
            <div class="itemname"></div>
            </div>`)
        } else if (event.data.type == "weapons") {
            $('.clearinv').append(`<div class="item">
            <div class="anzahl">` + item.amount + `</div>
            <div class="hr"></div>
            <div class="itemname">` + item.label +`</div>
            </div>`)
        } else if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        } else if (item.type === "setplayers") {
            $('#onlineplayers').text(item.players)
            $('#onlineadmins').text(item.admins)
        }
    });


    
    $(".ban").click(function () {
        let id = $(this).attr('id').replace('ban_', '');
        banselect = parseInt(id);
        $(".ban").removeClass('active');
        $(this).addClass('active');
    });

    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('https://keko_adminmenu/exit', JSON.stringify({}));
            return
        }
    };
  


    $("#close").click(function () {
        $.post('https://keko_adminmenu/exit', JSON.stringify({}));
        return
    })
    $(".leavespec").click(function () {
        $.post('https://keko_adminmenu/leavespecpls', JSON.stringify({}));
        return
    })

    $(".showbans").click(function () {
        $('#container').fadeOut(500)

        var ee = Math.floor(Math.random() * 1213213131313);

        $('#Canvas').append(`<div class="loader" style="margin-left: 45%; margin-top: 25%;" id='`+ ee +`'></div>`)

         $.post('https://keko_adminmenu/banlist', JSON.stringify({ 
         }), function(data){});

        setTimeout(function(){ 
            $('#' + ee).remove() 
            $('#banlist').fadeIn(500)
    }, 1500);
    })

    $("#returnme").click(function () {
        $('#container').fadeIn(500)
        $('#banlist').fadeOut(500)
    })

    $(".refresh").click(function () {
        $.post('https://keko_adminmenu/refreshplayers', JSON.stringify({}));
        return
    })

    $(".leavespec").click(function () {
        $.post('https://keko_adminmenu/leavespecpls', JSON.stringify({}));
        return
    })

    

    //when the user clicks on the submit button, it will run
    $("#submit").click(function () {
        let grundaction = $("#grundaction").text()
        if (grundaction.length < 10 || !grundaction) {
            console.log("Du musst einen Grund angeben")
            return
        }
        // if there are no errors from above, we can send the data back to the original callback and hanndle it from there
        $.post('https://keko_adminmenu/main', JSON.stringify({
            text: grundaction,
        }));
        return;
    })
})

function entbannen(license){
    $.post('https://keko_adminmenu/unban', JSON.stringify({license}));
}