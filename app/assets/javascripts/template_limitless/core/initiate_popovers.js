function initiateUsercard(){
    //Usercard
    $('.usercard').popover({ 
        trigger: "manual" , 
        html: true, 
        animation:false,
        template:'<div class="popover"><div class="popover-content"></div><div class="usercard-profile"></div><div class="arrow"></div></div>'
    })
        .mouseover(function(){
            $('.popover').hide();
            var that = this,
                user_uid = $(that).data("id"),
                usercard_url = "/usercard/"+user_uid+"/profile";      
                $.ajax({
                    url: usercard_url
                });
                $(that).popover("show");
            $(".popover").on("mouseleave", function () {
                $(that).popover('hide');
            });
        }).mouseleave(function () {
            var that = this;
            setTimeout(function () {
                if (!$(".popover:hover").length) {
                    $(that).popover("hide");
                }
            }, 300);
        }); 	
}

function refreshUsercard(popupclass){
    //Usercard
    $('.'+popupclass).popover({ 
        trigger: "manual" , 
        html: true, 
        animation:false,
        template:'<div class="popover"><div class="popover-content"></div><div class="usercard-profile"></div><div class="arrow"></div></div>'
    })
        .mouseover(function(){
            var that = this; 
            $('.popover').hide();
            var user_uid = $(that).data("id"),
                usercard_url = "/usercard/"+user_uid+"/profile";   
                $.ajax({
                    url: usercard_url
                });
                $(that).popover("show");
            $(".popover").on("mouseleave", function () {
                $(that).popover('hide');
            });
        }).mouseleave(function () {
            var that = this;
            setTimeout(function () {
                if (!$(".popover:hover").length) {
                    $(that).popover("hide");
                }
            }, 300);
        }); 	
}