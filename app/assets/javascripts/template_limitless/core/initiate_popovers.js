function refreshUsercard(popupclass){
    //Usercard
    var timer;
    $('.'+popupclass).popover({ 
        trigger: "manual" , 
        html: true, 
        animation:false,
        template:'<div class="popover"><div class="popover-content"></div><div class="usercard-profile"></div><div class="arrow"></div></div>'
    })
        .on("mouseenter",function(){
            $('.popover').hide();
            clearTimeout(timer);
            var that = this,
                timer = setTimeout(function() {
                    if($(that).is(':hover'))
                    {
                            user_uid = $(that).data("id"),
                        usercard_url = "/usercard/"+user_uid+"/profile";      
                        $.ajax({
                            url: usercard_url
                        });
                        $(that).popover("show");
                    }
                }, 400);
            $(".popover").on("mouseleave", function () {
                clearTimeout(timer);
                $('.popover').hide();
                $(that).popover('hide');
            });
        }).on("mouseleave",function () {
            var that = this;
            setTimeout(function () {
                if (!$(".popover:hover").length) {
                    clearTimeout(timer);
                    $('.popover').hide();
                    $(that).popover("hide");
                }
            }, 300);
        });  	
}