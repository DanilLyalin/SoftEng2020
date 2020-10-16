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
        <canvas height="640" width="320" id="Left"></canvas>
        <canvas height="700" width="320" id="GameWindow" style="margin-top: 1.5%;" ></canvas>
        <canvas height="700" width="320" id="LeaderBoard"style="margin-top: 1.5%; margin-left: 2px;"></canvas>
    </div>
    <div>
        <p id="top" style="visibility: hidden;">${top}</p>
    </div>
    <script>
        var GW = document.getElementById('GameWindow');
        var context = GW.getContext('2d');
        var LB = document.getElementById('LeaderBoard');
        var LBcontext = LB.getContext('2d');
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
        var score = 0;
        var gameSpeed = 100;

        function leaderBoard(){
            LBcontext.fillStyle = 'black';
            LBcontext.fillRect(0, 0, LB.width, LB.height);
            LBcontext.fillStyle = 'white';
            LBcontext.globalAlpha = 1;
            LBcontext.strokeStyle = 'black';
            LBcontext.fillRect(0, 0, LB.width, 60);
            LBcontext.strokeRect(0, 0, LB.width, 60);
            LBcontext.strokeRect(2, 2, LB.width-3, 58);
            LBcontext.globalAlpha = 1;
            LBcontext.fillStyle = 'black';
            LBcontext.font = '36px monospace';
            LBcontext.textAlign = 'center';
            LBcontext.textBaseline = 'middle';
            LBcontext.fillText('Leaderboard', LB.width / 2, 30);
            LBcontext.fillStyle = 'white';
            LBcontext.font = '30px monospace';
            let jsonTop = document.getElementById('top').innerHTML;
            jsonTop = JSON.parse(jsonTop);
            for(let i = 0; i < 10; i++){
                if (i < jsonTop.length){
                LBcontext.fillText(jsonTop[i].name+':'+jsonTop[i].score+'\n', LB.width / 2, 80+40*i);
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
            context.fillText('User score: '+ score, GW.width / 2, GW.height-30);
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
                    score++;
                    if(gameSpeed > 30){
                        gameSpeed -= 2;
                    }
                }
                counter = 0;
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
        putInArray(figure[0]);
        leaderBoard();
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
                    result = prompt("Game over! Your score: "+score+ "! Please enter your name.");
                    return;
                }
                requestAnimationFrame(game);
                figure[0] = randomInteger(1, 7);
                figure[1] = 0;
                putInArray(figure[0]);
            }
        }
        raf = requestAnimationFrame(game);
        
    </script>
</body>
</html>