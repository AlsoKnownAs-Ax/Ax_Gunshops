
const closeKey = "27";

var itemName = null;
var itemAmount = null;
var itemIdname = null;

var can_switch = true;
var vip_section = true;
var vip_access = false;

var title = null

function playSound() {
    var audio = document.getElementById("clickaudio");
    audio.volume = 0.05;
    audio.play();
}


// REUSABLE FUNCTIONS //

$("#container").hide();
$("#vip-guns").hide();
$('.buy-prompt').hide();

function formatNumber(num) {
    return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1.')
}

function clearSelectedItem() {
    itemName = null;
    itemAmount = null;
    itemIdname = null;
    $("#vip-guns").hide()
    $('#gs-desc').text("Normal Weapons");
    $("#guns div").css("background-color", "linear-gradient(to bottom left, rgba(0, 0, 0, 0.25), rgba(58, 58, 58, 0.2));");
    $("#guns").fadeIn();
    if($("#container").is(".blur")){
        $('#container').removeClass('blur');
    }
}

function display(bool) {
    if (bool) {
        $("#container").fadeIn();
    } else{
        $("#container").fadeOut();
        selection = 0;
        clearSelectedItem();
    }
}

window.addEventListener('message', function(event) {
    var data = event.data;

    if(data.open) {
        display(true);
        if(data.title){
            title = data.title;
            $("#gs-title").text(data.title);
        }
        if(!data.vip_section){
            $('#vip_wp').hide();
            vip_section = false;
        }
        else {
            $('#vip_wp').show();
            vip_section = true;   
        }
        if(data.items){

            $("#vip-guns").empty();

            $("#guns").empty();
            data.items.items_id.forEach(function(element, i){
                data.items.items_name.forEach(function(element2, i2){
                    if(i==i2)
                    {
                    $("#guns").append(`
                        <div onclick="selectItem(this)" data-it = "${i}" data-name = "${element2}"  data-idname="${element.item}" data-ammo_price = "${element.ammo_price}" data-price = "${element.price}" style="background-image: url('/img/${element.item}.png'); background-size: contain;background-repeat:no-repeat">
                            <p class="name">${element2}</br> <font style = "font-family: 'Orbitron', sans-serif;font-size: 1rem; font-weight: 400;" color='#00ff40'> ${formatNumber(element.price)} $</font></p>
                            ${element.ammo_price > 0 ? `<p class = 'ammo_price' id = "${i}">Ammo Price: ${formatNumber(element.ammo_price)} <font style = "font-family: 'Orbitron', sans-serif; font-weight: semi-bold;" color='green'>$</font></p>` : ""} 
                        </div>
                    `);
                    };
                });
                i = i + 1;
            });
            
            if(data.vip_section){
                vip_access = data.vip_access
                if(data.vip_access){
                    if(data.items.vip_weapons_ids != null){
                        data.items.vip_weapons_ids.forEach(function(element, i){
                            data.items.vip_weapons.forEach(function(element2, i2){
                                if(i==i2)
                                {
                                $("#vip-guns").append(`
                                    <div onclick="selectItem(this)" data-it = "${i}" data-name = "${element2}"  data-idname="${element.item}" data-ammo_price = "${element.ammo_price}" data-price = "${element.price}" style="background-image: url('/img/${element.item}.png'); background-size: contain;background-repeat:no-repeat">
                                        <p class="name">${element2}</br> <font style = "font-family: 'Orbitron', sans-serif;font-size: 1rem; font-weight: 400;" color='#00ff40'> ${formatNumber(element.price)} $</font></p>
                                        ${element.ammo_price > 0 ? `<p class = 'ammo_price' id = "${i}">Ammo Price: ${formatNumber(element.ammo_price)} <font style = "font-family: 'Orbitron', sans-serif; font-weight: semi-bold;" color='green'>$</font></p>` : ""} 
                                    </div>
                                `);
                                };
                            });
                            i = i + 1;
                        });
                    }
                }
            }

            // HOVER Sound

            $("#guns div").hover(function(){
                if(!$(this).is('.selected-item')){    // if is not selected play the hover sound
                    playSound();
                }
            });
            $("#vip-guns div").hover(function(){
                if(!$(this).is('.selected-item')){ 
                    playSound()
                }
            });
        }
    } else{
        display(false);
    }
});

var selection = 0;

function selectItem(element) {
    itemName = element.dataset.name;
    itemIdname = element.dataset.idname;
    item_it = element.dataset.it;

    $("#guns div").css("background-color", "linear-gradient(to bottom left, rgba(0, 0, 0, 0.25), rgba(58, 58, 58, 0.2));");
    $("#vip-guns div").css("background-color", "linear-gradient(to bottom left, rgba(0, 0, 0, 0.25), rgba(58, 58, 58, 0.2));");
    
    if(!$(element).is(".selected-item")){
        selection = selection + 1;
        $(element).addClass("selected-item");
        $(element).addClass("nohover");
        $(element).append(`<i id="${item_it}" class="fa-solid fa-circle-check"></i>`);
    }else{
        selection = selection - 1;
        if(selection < 0 ){ // Avoiding Bugs
            selection = 0;
        }
        $("i").remove(`#${item_it}`);
        $(element).removeClass("selected-item");
        $(element).removeClass("nohover");
    };
}

function clearBuyPrompt(){
    $(".buy-prompt").toggle();
    $(".guns__inputs").empty();
    $('.shop_container').toggle();
    clear_items_array();
};

$(document).ready(function(){
    document.onkeyup = function(data) {
        if (data.which == closeKey) {
            if($("#container").is(".blur")){
                clearBuyPrompt()
                clearSelectedItem();
            }else{
                $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
            }
        }
    };
});

$(document).on('click', ".closeGS", function() {
    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
});

$(document).on('click', ".closePrompt", function() {
    clearBuyPrompt()
    clearSelectedItem();
});

$(document).on('click', "#normal_wp", function() {
    $("#gs-title").fadeOut();
    $("#gs-desc").fadeOut('slow', function(){
        $("#gs-desc").fadeIn();
        $("#gs-title").fadeIn();
        $('#gs-desc').text("Normal Weapons");
        $('#gs-title').text(title);
    });
    $("#vip-guns").fadeOut('slow',function(){
        $("#guns").fadeIn();
    });
});

$(document).on('click', ".button", function() {
    $(document).ready(function(){
        if(selection > 0){
            $('#container').addClass('blur');
            $('.buy-prompt').fadeIn('slow',function(){
                $('.shop_container').fadeIn();
            });
            $('.selected-item').each(function(i, obj) {
                var item_name = obj.dataset.name;
                var item_id = obj.dataset.idname.toUpperCase();

                // Adding input methods for the customer

                if(!item_id.search("WEAPON")){
                $(".guns__inputs").append(`
                    <h3>${item_name} Ammo</h3>
                    <input type="number" placeholder = "Amount" class = "amount_input" id ="input-${i}">
                    <p></p>
                `);
                }else{
                    $(".guns__inputs").append(`
                    <h3>${item_name}</h3>
                    <input type="number" placeholder = "Amount" class = "amount_input" id = "input-${i}">
                    <p></p>
                `);
                };
            });
        }else{
            $.post(`https://${GetParentResourceName()}/noslected`, JSON.stringify({}))
        };
    });
});



$(document).on('click', "#vip_wp", function() {
    if(vip_access){
        $("#gs-title").fadeOut();
        $("#gs-desc").fadeOut('slow',function(){
            $("#gs-desc").fadeIn();
            $("#gs-title").fadeIn();
            $('#gs-desc').text("V.I.P Weapons");
            $('#gs-title').text("Armament V.I.P");
        });
        $("#guns").fadeOut('slow',function(){
            $("#vip-guns").fadeIn();
        });
    }else{
        $.post(`https://${GetParentResourceName()}/novipnotify`, JSON.stringify({}));
    }   

});

var items_array = {"weapons":[],"non_weapons_items":[]}

// var total_price = 0;

// function Add_total_price(number){
//     total_price = total_price + number;
// }

function SubmitAmount(obj,number){
    //let weapon_name = obj.dataset.name;
    let weapon_id = obj.dataset.idname.toUpperCase();
    let price = obj.dataset.price

    // Adding the price to the total and sending data to client

    if(!weapon_id.search("WEAPON")){
        let ammo_price = obj.dataset.ammo_price;
        if(ammo_price == null || ammo_price == ""){
            ammo_price = 0;
        }
        items_array['weapons'].push({"item_id":weapon_id,"ammo_amount":number,"body_price":price,"ammo_price":ammo_price});
    }else{
        items_array['non_weapons_items'].push({"item_id":weapon_id,"amount":number,"price":price});
    };    
};

function clear_items_array(){
    items_array = {"weapons":[],"non_weapons_items":[]};
}


$(document).on('click', ".shop_container", function() {
    // Getting values from inputs
    $('.selected-item').each(function(i, obj) {
        let amount = document.getElementById(`input-${i}`).value;
        if(amount=="" || amount == null){
            amount = 0;
        }
        SubmitAmount(obj,amount);
    });
    $.post(`https://${GetParentResourceName()}/buy-items`, JSON.stringify({items_array}));
    clear_items_array();
    clearBuyPrompt();
    display(false);
    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
});