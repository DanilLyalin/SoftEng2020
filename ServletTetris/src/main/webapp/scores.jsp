<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <style>
        html { overflow:  hidden; }
    </style>
</head>
<body>
    <div class="gameWind" style="width: 100%;
                                 height: 100%;
                                 position: absolute;
                                 top: 0;
                                 left: 0;
                                 overflow: auto;
                                 white-space: nowrap;
                                 text-align: center;
                                 font-size: 0;">
        <canvas height="700" width="320" id="Left" style="margin-top: 1.5%; margin-right: 2px;"></canvas>
        <canvas height="700" width="320" id="LeaderBoard" style="margin-top: 1.5%;" ></canvas>
        <canvas height="700" width="320" id="Right"style="margin-top: 1.5%; margin-left: 2px;"></canvas>
    </div>
    <div>
        <p id="all" style="visibility: hidden;">${all}</p>
    </div>
<script>
    var LB = document.getElementById('LeaderBoard');
    var LBcontext = LB.getContext('2d');
    var Left = document.getElementById('Left');
    var Leftcontext = Left.getContext('2d');

    function leaderBoard(){
            let jsonTop = document.getElementById('all').innerHTML;
            jsonTop = JSON.parse(jsonTop);
            LB.height = 40 * jsonTop.length + 80;
            Left.height = LB.height;
            LBcontext.fillStyle = 'black';
            LBcontext.fillRect(0, 0, LB.width, LB.height);
            LBcontext.fillStyle = 'white';
            LBcontext.globalAlpha = 1;
            LBcontext.strokeStyle = 'black';
            LBcontext.fillRect(0, 0, LB.width, 60);
            LBcontext.strokeRect(0, 0, LB.width, 60);
            LBcontext.strokeRect(2, 2, LB.width-3, 58);
            LBcontext.globalAlpha = 1;
            LBcontext.fillStyle = 'white';
            LBcontext.fillRect(LB.width/3*2, 3, 2, LB.height);
            LBcontext.fillStyle = 'black';
            LBcontext.font = '36px monospace';
            LBcontext.textAlign = 'center';
            LBcontext.textBaseline = 'middle';
            LBcontext.fillText('Leaderboard', LB.width / 2, 30);
            LBcontext.fillStyle = 'white';
            LBcontext.font = '30px monospace';
            let numSpaces;
            let spaces ="";
            for(let i = 0; i < jsonTop.length; i++){
                if (i < jsonTop.length){
                numSpaces = 14 - jsonTop[i].name.length;
                for(let y = 0; y < numSpaces; y++){
                    spaces += " ";
                }
                LBcontext.fillText(jsonTop[i].name+spaces+jsonTop[i].score+'\n', LB.width / 2, 80+40*i);
                }
                spaces ="";
            }
        }

        function drawButtonBack(){
            var btnBack = {
                x:Left.width/2 - 60,
                y:10,
                w:120,
                h:40,
                text:"Go back",
                state:"default",
                draw: function(){
                    Leftcontext.font = "20px Arial ";
                    switch(this.state){
                        case "over":      
                        Leftcontext.fillStyle = "red";
                            Leftcontext.fillRect(this.x,this.y,this.w,this.h);
                        Leftcontext.fillStyle = "black";
                        Leftcontext.fillText("Go back?",this.x+this.w/2 - Leftcontext.measureText("Go back").width/2,this.y+this.h/2+10 );
                    break;
                        default:
                        Leftcontext.fillStyle = "gray";
                            Leftcontext.fillRect(this.x,this.y,this.w,this.h);
                        Leftcontext.fillStyle = "black";
                        Leftcontext.fillText("Go back",this.x+this.w/2 - Leftcontext.measureText("Go back").width/2,this.y+this.h/2+10 );
                    }
                }
            };
            btnBack.draw();
            Left.addEventListener("mousedown",function(e){
                    if(checkCollision(e.offsetX,e.offsetY,btnBack )){
                            document.location.href = "http://localhost:8080/ServletTetris/game";
                        }
            },false);
            
            
            Left.addEventListener("mousemove",function(e){
            btnBack.state = checkCollision(e.offsetX,e.offsetY,btnBack )?"over":"def";
                btnBack.draw();
            },false);
            
            function checkCollision(x,y,obj){
                return x >= obj.x && x <= obj.x + obj.w &&
                y >= obj.y && y <= obj.y + obj.h ;
            }
        }
        
        leaderBoard();
        drawButtonBack();
</script>
</body>
</html>