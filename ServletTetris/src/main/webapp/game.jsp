<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body style="background: whitesmoke;">
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
        <canvas height="700" width="320" id="GameWindow" style="margin-top: 1.5%;" ></canvas>
        <canvas height="700" width="340" id="LeaderBoard"style="margin-top: 1.5%; margin-left: 20px;"></canvas>
    </div>
    <div>
        <p id="top" style="visibility: hidden;">${top}</p>
    </div>
    
    <script>
        var GW = document.getElementById('GameWindow');
        var context = GW.getContext('2d');
        var LB = document.getElementById('LeaderBoard');
        var LBcontext = LB.getContext('2d');
        var Left = document.getElementById('Left');
        var Leftcontext = Left.getContext('2d');
        const pixelSize = 32;
        const heightInPixel = 24;
        const widthInPixel = 12;
        var arrayOfPixels = [];
        for(let i = 0; i < heightInPixel; i++)
        {
            arrayOfPixels[i] = [];
            for(let j = 0; j < widthInPixel; j++){
                if(j == 0 || j == 11){
                    arrayOfPixels[i][j] = 1;
                }
                else{
                    arrayOfPixels[i][j] = 0;
                }
            }
        }
        var playing = true;
        var figurePos = [[0,0],[0,0],[0,0],[0,0]];
        var savePos = [[0,0],[0,0],[0,0],[0,0]];
        var move = true;
        var fps = 0;
        var figure = [0,0];
        var scores = 0;
        var gameSpeed = 100;
        var nextFig = 0;
        var nextFigString = "00000000";

        function drawNextText(){
            Leftcontext.fillStyle = 'white';
            Leftcontext.globalAlpha = 1;
            Leftcontext.strokeStyle = 'black';
            Leftcontext.fillRect(Left.width/2, 0, LB.width, 60);
            Leftcontext.strokeRect(Left.width/2-53, 0, pixelSize*6-1, 60);
            Leftcontext.strokeRect(Left.width/2-51, 2, pixelSize*6-3, 58);
            Leftcontext.fillStyle = 'black';
            Leftcontext.font = '36px monospace';
            Leftcontext.textAlign = 'center';
            Leftcontext.textBaseline = 'middle';
            Leftcontext.fillText('Next', Left.width/2 + 45, 35);
        }

        function drawNextFigure(nextNum){
            Leftcontext.fillStyle = 'black';
            Leftcontext.fillRect(Left.width/3, 60, pixelSize*6, pixelSize*4);
            Leftcontext.fillStyle = 'red';
            switch(nextNum){
                case(1): nextFigString = "001100001100";
                         break;
                case(2): nextFigString = "011110000000";
                         break;
                case(3): nextFigString = "000110001100";
                         break;
                case(4): nextFigString = "001100000110";
                         break;
                case(5): nextFigString = "000010001110";
                         break;
                case(6): nextFigString = "010000011100";
                         break;
                case(7): nextFigString = "001110000100";
                         break;
            }
            console.log(nextFigString);
            for(let y = 0; y < 2; y++){
                for(let x = 0; x < 6; x++){
                    if(nextFigString[y*6+x] == "1"){
                        Leftcontext.fillRect(Left.width/3+pixelSize*x, 60+pixelSize+y*pixelSize, pixelSize, pixelSize);
                    }
                }
            }
            Leftcontext.strokeStyle = 'gray';
            for(let y = 60; y < 60+pixelSize*4; y+=pixelSize){
                for(let x = Left.width/3; x < Left.width/3+pixelSize*6; x+=pixelSize){
                    Leftcontext.strokeRect(x, y, pixelSize, pixelSize);
                }
            }
        }

        function drawButtonRestart(){
            var btnRestart = {
                x:Left.width/2 - 22,
                y:Left.height/3 - 20,
                w:130,
                h:45,
                text:"Restart",
                state:"default",
                draw: function(){
                    Leftcontext.font = "20px Arial ";
                    switch(this.state){
                        case "over":      
                        Leftcontext.fillStyle = "red";
                        Leftcontext.fillRect(this.x,this.y,this.w,this.h);
                        Leftcontext.fillStyle = "black";
                        Leftcontext.fillText("Restart?",this.x+65,this.y+this.h/2+4 );
                    break;
                        default:
                        Leftcontext.fillStyle = "gray";
                        Leftcontext.fillRect(this.x,this.y,this.w,this.h);
                        Leftcontext.fillStyle = "black";
                        Leftcontext.fillText("Restart",this.x+65,this.y+this.h/2+4 );
                    }
                }
            };
            btnRestart.draw();
            Left.addEventListener("mousedown",function(e){
                    if(checkCollision(e.offsetX,e.offsetY,btnRestart )){
                        if(playing != false){
                            playing = false;
                            result = confirm("Are you sure? Your scores will be lost!");
                            if (result == true){
                            document.location.href = "http://localhost:8080/ServletTetris/game";
                            }
                            playing = true;
                        }
                        else{
                            document.location.href = "http://localhost:8080/ServletTetris/game";
                        }
                    }
            },false);
            
            
            Left.addEventListener("mousemove",function(e){
            btnRestart.state = checkCollision(e.offsetX,e.offsetY,btnRestart )?"over":"def";
                btnRestart.draw();
            },false);
            
            function checkCollision(x,y,obj){
                return x >= obj.x && x <= obj.x + obj.w &&
                y >= obj.y && y <= obj.y + obj.h ;
            }
        }

        function drawButtonLeaderboard(){
            var btnLB = {
                x:Left.width/2 - 22,
                y:Left.height/3 + 40,
                w:130,
                h:45,
                text:"Leaderboard",
                state:"default",
                draw: function(){
                    Leftcontext.font = "20px Arial ";
                    switch(this.state){
                        case "over":      
                        Leftcontext.fillStyle = "red";
                        Leftcontext.fillRect(this.x,this.y,this.w,this.h);
                        Leftcontext.fillStyle = "black";
                        Leftcontext.fillText("Open?",this.x+65,this.y+this.h/2+4 );
                    break;
                        default:
                        Leftcontext.fillStyle = "gray";
                        Leftcontext.fillRect(this.x,this.y,this.w,this.h);
                        Leftcontext.fillStyle = "black";
                        Leftcontext.fillText("Leaderboard",this.x+65,this.y+this.h/2+4);
                    }
                }
            };
            btnLB.draw();
            Left.addEventListener("mousedown",function(e){
                    if(checkCollision(e.offsetX,e.offsetY,btnLB )){
                        if(playing != false){
                            playing = false;
                            result = confirm("Are you sure? Your scores will be lost!");
                            if (result == true){
                            document.location.href = "http://localhost:8080/ServletTetris/scores";
                            }
                            playing = true;
                        }
                        else{
                            document.location.href = "http://localhost:8080/ServletTetris/scores";
                        }
                    }
            },false);
            
            
            Left.addEventListener("mousemove",function(e){
            btnLB.state = checkCollision(e.offsetX,e.offsetY,btnLB )?"over":"def";
                btnLB.draw();
            },false);
            
            function checkCollision(x,y,obj){
                return x >= obj.x && x <= obj.x + obj.w &&
                y >= obj.y && y <= obj.y + obj.h ;
            }
        }

        function leaderBoard(){
            let jsonTop = document.getElementById('top').innerHTML;
            jsonTop = JSON.parse(jsonTop);
            LBcontext.fillStyle = 'black';
            LBcontext.fillRect(0, 0, LB.width, 460);
            LBcontext.fillStyle = 'white';
            LBcontext.globalAlpha = 1;
            LBcontext.strokeStyle = 'black';
            LBcontext.fillRect(0, 0, LB.width, 60);
            LBcontext.strokeRect(0, 0, LB.width, 60);
            LBcontext.strokeRect(2, 2, LB.width-3, 58);
            LBcontext.globalAlpha = 1;
            LBcontext.fillStyle = 'white';
            LBcontext.fillRect(LB.width/3*2, 3, 2, 460);
            LBcontext.fillStyle = 'black';
            LBcontext.font = '36px monospace';
            LBcontext.textAlign = 'center';
            LBcontext.textBaseline = 'middle';
            LBcontext.fillText('Top-10 players', LB.width / 2, 30);
            LBcontext.fillStyle = 'white';
            LBcontext.font = '30px monospace';
            let numSpaces;
            let spaces ="";
            for(let i = 0; i < jsonTop.length; i++){
                if (i < jsonTop.length){
                LBcontext.textAlign = 'left';
                LBcontext.fillText(jsonTop[i].name, 20 , 80+40*i);
                LBcontext.textAlign = 'right';
                LBcontext.fillText(jsonTop[i].score+'\n', LB.width -10 , 80+40*i);
                }
            }
        }

        function drawGame(){
            context.fillStyle = 'black';
            context.fillRect(0, 0, GW.width, GW.height);
            context.fillStyle = 'yellow';
            for(let y = 0; y < heightInPixel; y++){
                for(let x = 0; x < widthInPixel; x++){
                    if(arrayOfPixels[y][x] == 1)
                    context.fillRect((x-1)*pixelSize, (y-2)*pixelSize, pixelSize, pixelSize);
                }
            }
            context.fillStyle = 'red';
            for(let i = 0; i < 4; i++){
                    context.fillRect((figurePos[i][1]-1)*pixelSize, (figurePos[i][0]-2)*pixelSize, pixelSize, pixelSize);
            }
            context.strokeStyle = 'gray';
            for(let y = 0; y < heightInPixel-2; y++){
                for(let x = 0; x < widthInPixel; x++){
                    context.strokeRect(x*pixelSize, y*pixelSize, pixelSize, pixelSize);
                }
            }
            context.fillStyle = 'white';
            context.globalAlpha = 1;
            context.fillRect(0, GW.height-60, GW.width, 60);
            context.globalAlpha = 1;
            context.fillStyle = 'black';
            context.font = '36px monospace';
            context.textAlign = 'center';
            context.textBaseline = 'middle';
            context.fillText('User score: '+ scores, GW.width / 2, GW.height-30);
            context.strokeStyle = 'black';
            context.strokeRect(0, GW.height-60, GW.width, 60);
            context.strokeRect(2, GW.height-58, GW.width-3, 58);
        }

        function putInArray(fig){
            switch(fig){
                case(1): //O
                    arrayOfPixels[0][5] = 2;
                    arrayOfPixels[0][6] = 2;
                    arrayOfPixels[1][5] = 2;
                    arrayOfPixels[1][6] = 2;
                    figurePos[0][0] = 1;
                    figurePos[1][0] = 1;
                    figurePos[2][0] = 2;
                    figurePos[3][0] = 2;
                    figurePos[0][1] = 5;
                    figurePos[1][1] = 6;
                    figurePos[2][1] = 5;
                    figurePos[3][1] = 6;
                    break;
                case(2): // |
                    arrayOfPixels[1][4] = 2;
                    arrayOfPixels[1][5] = 2;
                    arrayOfPixels[1][6] = 2;
                    arrayOfPixels[1][7] = 2;
                    for(let i = 0; i < 4; i++){
                        figurePos[i][0] = 2;
                    }
                    figurePos[0][1] = 4;
                    figurePos[1][1] = 5;
                    figurePos[2][1] = 6;
                    figurePos[3][1] = 7;
                    break;    
                case(3): // S
                    arrayOfPixels[0][5] = 2;
                    arrayOfPixels[0][6] = 2;
                    arrayOfPixels[1][4] = 2;
                    arrayOfPixels[1][5] = 2;
                    figurePos[0][0] = 1;
                    figurePos[1][0] = 1;
                    figurePos[2][0] = 2;
                    figurePos[3][0] = 2;
                    figurePos[0][1] = 5;
                    figurePos[1][1] = 6;
                    figurePos[2][1] = 4;
                    figurePos[3][1] = 5;
                    break;
                case(4): // Z
                    arrayOfPixels[0][4] = 2;
                    arrayOfPixels[0][5] = 2;
                    arrayOfPixels[1][5] = 2;
                    arrayOfPixels[1][6] = 2;
                    figurePos[0][0] = 1;
                    figurePos[1][0] = 1;
                    figurePos[2][0] = 2;
                    figurePos[3][0] = 2;
                    figurePos[0][1] = 4;
                    figurePos[1][1] = 5;
                    figurePos[2][1] = 5;
                    figurePos[3][1] = 6;
                    break;
                case(5): //L
                    arrayOfPixels[0][5] = 2;
                    for(i = 3; i < 6; i++){
                        arrayOfPixels[1][i] = 2;
                    }
                    figurePos[0][0] = 1;
                    figurePos[1][0] = 2;
                    figurePos[2][0] = 2;
                    figurePos[3][0] = 2;
                    figurePos[0][1] = 5;
                    figurePos[1][1] = 3;
                    figurePos[2][1] = 4;
                    figurePos[3][1] = 5;
                    break;
                case(6): //J
                    arrayOfPixels[0][5] = 2;
                    for(i = 5; i < 8; i++){
                        arrayOfPixels[1][i] = 2;
                    }
                    figurePos[0][0] = 1;
                    figurePos[1][0] = 2;
                    figurePos[2][0] = 2;
                    figurePos[3][0] = 2;
                    figurePos[0][1] = 5;
                    figurePos[1][1] = 5;
                    figurePos[2][1] = 6;
                    figurePos[3][1] = 7;
                    break; 
                case(7): // T
                    arrayOfPixels[0][5] = 2;
                    arrayOfPixels[0][6] = 2;
                    arrayOfPixels[0][7] = 2;
                    arrayOfPixels[1][6] = 2;
                    figurePos[0][0] = 1;
                    figurePos[1][0] = 1;
                    figurePos[2][0] = 1;
                    figurePos[3][0] = 2;
                    figurePos[0][1] = 5;
                    figurePos[1][1] = 6;
                    figurePos[2][1] = 7;
                    figurePos[3][1] = 6;
                    break;       
                default: break;
            }
        }

        function moveDown(){
            for(let i = 0; i < 4; i++){
                arrayOfPixels[figurePos[i][0]][figurePos[i][1]] = 0;
                arrayOfPixels[figurePos[i][0]+1][figurePos[i][1]] = 2;
                figurePos[i][0] +=1
            }
        }

        function moveLeft(){
            for(let i = 0; i < 4; i++){
                arrayOfPixels[figurePos[i][0]][figurePos[i][1]] = 0;
                arrayOfPixels[figurePos[i][0]][figurePos[i][1]-1] = 2;
                figurePos[i][1] -=1
            }
        }

        function moveRight(){
            for(let i = 0; i < 4; i++){
                arrayOfPixels[figurePos[i][0]][figurePos[i][1]] = 0;
                arrayOfPixels[figurePos[i][0]][figurePos[i][1]+1] = 2;
                figurePos[i][1] +=1
            }
        }

        function rotateCheck(){
            for(let i = 0; i < 4; i++){
                for(let j = 0; j < 4; j++){
                    if(arrayOfPixels[figurePos[i][0]][figurePos[i][1]] == 1 || !movingCheck('down')){
                        for(let i = 0; i < 4; i++){
                            for(let j = 0; j < 4; j++){
                                figurePos[i][j] = savePos[i][j];
                            }
                        }
                        return false;
                    }
                }
            }
            return true;
        }

        function rotate(){
            cancelAnimationFrame(raf);
            for(let i = 0; i < 4; i++){
                for(let j = 0; j < 4; j++){
                    savePos[i][j] = figurePos[i][j];
                }
            }
            switch(figure[0]){
                case(1): break;
                case(2):switch(figure[1]){
                            case(0):
                                figurePos[0][0] -= 1;
                                figurePos[2][0] += 1;
                                figurePos[3][0] += 2;
                                figurePos[0][1] += 1;
                                figurePos[2][1] -= 1;
                                figurePos[3][1] -= 2;
                                figure[1] = 1;
                                if(!rotateCheck()){
                                    figure[1] = 0;
                                }
                                break;
                            case(1):
                                figurePos[0][0] += 1;
                                figurePos[2][0] -= 1;
                                figurePos[3][0] -= 2;
                                figurePos[0][1] -= 1;
                                figurePos[2][1] += 1;
                                figurePos[3][1] += 2;
                                figure[1] = 0;
                                if(!rotateCheck()){
                                    figure[1] = 1;
                                }rotateCheck();
                                break;   
                        }
                        break;
                case(3):switch(figure[1]){
                            case(0):
                                figurePos[2][1] += 1;
                                figurePos[3][1] += 1;
                                figurePos[2][0] -= 2;
                                figure[1] = 1;
                                if(!rotateCheck()){
                                    figure[1] = 0;
                                }
                                break;
                            case(1):
                                figurePos[2][1] -= 1;
                                figurePos[3][1] -= 1;
                                figurePos[2][0] += 2;
                                figure[1] = 0;
                                if(!rotateCheck()){
                                    figure[1] = 1;
                                }
                                break;
                            }
                            break;
                case(4):switch(figure[1]){
                            case(0):
                                figurePos[3][1] -= 1;
                                figurePos[2][1] -= 1;
                                figurePos[3][0] -= 2;
                                figure[1] = 1;
                                if(!rotateCheck()){
                                    figure[1] = 0;
                                }
                                break;
                            case(1):
                                figurePos[3][1] += 1;
                                figurePos[2][1] += 1;
                                figurePos[3][0] += 2;
                                figure[1] = 0;
                                if(!rotateCheck()){
                                    figure[1] = 1;
                                }
                                break;
                            }
                            break;
                case(5):switch(figure[1]){
                            case(0):
                                figurePos[0][0] += 2;
                                figurePos[1][0] -= 1;
                                figurePos[3][0] += 1;
                                figurePos[1][1] += 1;
                                figurePos[3][1] -= 1;
                                figure[1] = 1;
                                if(!rotateCheck()){
                                    figure[1] = 0;
                                }
                                break;
                            case(1):
                                figurePos[1][0] += 1;
                                figurePos[3][0] -= 1;
                                figurePos[0][1] -= 2;
                                figurePos[1][1] += 1;
                                figurePos[3][1] -= 1;
                                figure[1] = 2;
                                if(!rotateCheck()){
                                    figure[1] = 1;
                                }
                                break;
                            case(2):
                                figurePos[0][0] -= 2;
                                figurePos[1][0] += 1;
                                figurePos[3][0] -= 1;
                                figurePos[1][1] -= 1;
                                figurePos[3][1] += 1;
                                figure[1] = 3;
                                if(!rotateCheck()){
                                    figure[1] = 2;
                                }
                                break;
                            case(3):
                                figurePos[1][0] -= 1;
                                figurePos[3][0] += 1;
                                figurePos[0][1] += 2;
                                figurePos[1][1] -= 1;
                                figurePos[3][1] += 1;
                                figure[1] = 0;
                                if(!rotateCheck()){
                                    figure[1] = 3;
                                }
                                break;
                            }
                            break;
                case(6):switch(figure[1]){
                            case(0):
                                figurePos[1][0] -= 1;
                                figurePos[3][0] += 1;
                                figurePos[0][1] += 2;
                                figurePos[1][1] += 1;
                                figurePos[3][1] -= 1;
                                figure[1] = 1;
                                if(!rotateCheck()){
                                    figure[1] = 0;
                                }
                                break;
                            case(1):
                                figurePos[0][0] += 2;
                                figurePos[1][0] += 1;
                                figurePos[3][0] -= 1;
                                figurePos[1][1] += 1;
                                figurePos[3][1] -= 1;
                                figure[1] = 2;
                                if(!rotateCheck()){
                                    figure[1] = 1;
                                }
                                break;
                            case(2):
                                figurePos[1][0] += 1;
                                figurePos[3][0] -= 1;
                                figurePos[0][1] -= 2;
                                figurePos[1][1] -= 1;
                                figurePos[3][1] += 1;
                                figure[1] = 3;
                                if(!rotateCheck()){
                                    figure[1] = 2;
                                }
                                break;
                            case(3):
                                figurePos[0][0] -= 2;
                                figurePos[1][0] -= 1;
                                figurePos[3][0] += 1;
                                figurePos[1][1] -= 1;
                                figurePos[3][1] += 1;
                                figure[1] = 0;
                                if(!rotateCheck()){
                                    figure[1] = 3;
                                }
                                break;
                            }
                            break;
                case(7):switch(figure[1]){
                            case(0):
                                figurePos[2][0] -= 1;
                                figurePos[2][1] -= 1;
                                figure[1] = 1;
                                if(!rotateCheck()){
                                    figure[1] = 0;
                                }
                                break;
                            case(1):
                                figurePos[3][0] -= 1;
                                figurePos[3][1] += 1;
                                figure[1] = 2;
                                if(!rotateCheck()){
                                    figure[1] = 1;
                                }
                                break;
                            case(2):
                                figurePos[0][0] += 1;
                                figurePos[0][1] += 1;
                                figure[1] = 3;
                                if(!rotateCheck()){
                                    figure[1] = 2;
                                }
                                break;
                            case(3):
                                figurePos[0][0] -= 1;
                                figurePos[2][0] += 1;
                                figurePos[3][0] += 1;
                                figurePos[0][1] -= 1;
                                figurePos[2][1] += 1;
                                figurePos[3][1] -= 1;
                                figure[1] = 0;
                                if(!rotateCheck()){
                                    figure[1] = 3;
                                }
                                break;
                            }
                            break;
            }
            requestAnimationFrame(game);
        }

        document.addEventListener('keydown', function(e) {
            // 37 ←, 38 ↑, 39 →, 40 ↓;
            if (playing){
                switch(e.which){
                    case(37): if(movingCheck('left')){
                                moveLeft();
                                };
                            break;
                    case(39): if(movingCheck('right')){
                                moveRight();
                            };
                            break;
                    case(38): rotate();
                                break;
                    case(40): if(movingCheck('down')){
                                moveDown();
                                }
                            break;
                    default: break;
                }
            }
        });

        function movingCheck(side){
            switch(side){
                case('left'): for(let i = 0; i < 4; i++){
                                    if(arrayOfPixels[figurePos[i][0]][figurePos[i][1]-1] == 1)
                                    {
                                        return false;
                                    }
                              }
                              break;
                case('right'):for(let i = 0; i < 4; i++){
                                    if(arrayOfPixels[figurePos[i][0]][figurePos[i][1]+1] == 1 || figurePos[i][1]+1 >= widthInPixel)
                                    {
                                        return false;
                                    }
                              }
                              break;
                case('down'): for(let i = 0; i < 4; i++){
                                    if(arrayOfPixels[figurePos[i][0]+1][figurePos[i][1]] == 1 || figurePos[i][0]+1 > heightInPixel-3 || figurePos[i][0]+1 < 0)
                                    {
                                        return false;
                                    }
                              }
                              break;
            }
            return true;
        }

        function saveState(){
            for(let i = 0; i < 4; i++){
                arrayOfPixels[figurePos[i][0]][figurePos[i][1]] = 1;
            }
        }

        function randomInteger(min, max) {
            let rand = min + Math.random() * (max + 1 - min);
            return Math.floor(rand);
        }

        function cleanLine(){
            let multiplier = 0;
            let counter = 0;
            for(let i = 2; i < heightInPixel; i++){
                for(let j = 1; j < widthInPixel; j++){
                    if(arrayOfPixels[i][j] == 1){
                        counter++;
                    }
                }
                if(counter > 10){
                    for(let x = i; x > 2; x--){
                        for(let y = 1; y < widthInPixel; y++){
                            arrayOfPixels[x][y] = arrayOfPixels[x-1][y];
                        }
                    }
                    multiplier++
                    if(gameSpeed > 30){
                        gameSpeed -= 2;
                    }
                }
                counter = 0;
            }
            if (multiplier > 0){
                scores += 10 + 20 * (multiplier-1);
            }
        }

        function stopGame(){
            for(let i = 1; i < widthInPixel-1; i++){
                if(arrayOfPixels[1][i] == 1){
                    playing = false;
                }
            }
        }

        figure[0] = randomInteger(1, 7);
        figure[1] = 0;
        nextFig = randomInteger(1,7);
        putInArray(figure[0]);
        leaderBoard();
        drawNextText();
        drawNextFigure(nextFig);
        drawButtonRestart();
        drawButtonLeaderboard();
        function game(){
            fps++;
            drawGame();
            raf = requestAnimationFrame(game);
            if(move && movingCheck('down')){
                if(++fps > gameSpeed){
                    moveDown();
                    fps = 0;
                }
            }
            else{
                cancelAnimationFrame(raf);
                saveState();
                cleanLine();
                stopGame();
                if(!playing){
                    drawGame();
                    let check = true;
                    let numGoodChar;
                    let first = true;
                    result = prompt("Game over! Your score: "+scores+ "! Please enter your name (Use only a-z, A-Z, 0-9, and 11 letters max).");
                    while (check){
                        if (!first) {
                            result = prompt("Please try to enter your name again (Use only a-z, A-Z, 0-9, and 11 letters max).");
                        }
                        first = false;
                        if (result.length > 11)
                        {
                            continue;
                        }
                        numGoodChar = 0;
                        for(let i = 0; i < result.length; i++){
                                if(result.charCodeAt(i) >= 'a'.charCodeAt(0) && result.charCodeAt(i) <= 'z'.charCodeAt(0) || 
                                result.charCodeAt(i) >= 'A'.charCodeAt(0) && result.charCodeAt(i) <= 'Z'.charCodeAt(0) || 
                                result.charCodeAt(i) >= '0'.charCodeAt(0) && result.charCodeAt(i) <= '9'.charCodeAt(0))
                                {
                                    numGoodChar += 1;
                                }
                            }
                        if (result.length == numGoodChar){
                            check = false;
                        }
                    }
                    let Player = {
                        name: "",
                        score: 0
                    }
                    Player.name = result;
                    Player.score = scores;
                    var xhr = new XMLHttpRequest();
                    var body = JSON.stringify(Player);
                    xhr.open("POST", 'http://localhost:8080/ServletTetris/scores/add', true);
                    xhr.send(body);
                    alert("Added successfully");
                    return;
                }
                requestAnimationFrame(game);
                figure[0] = nextFig;
                figure[1] = 0;
                nextFig = randomInteger(1,7);
                putInArray(figure[0]);
                drawNextFigure(nextFig);
            }
        }
        raf = requestAnimationFrame(game);
        
    </script>
</body>
</html>