/**
* Snakes and Ladders game for Programming Languages course
* @author Oscar Nierstrasz, (c) 2012
*/

// === ASSERTIONS ==================================================
// Two ways of handling assertion violations
// Pick one, or use both ...
function assert(outcome, message) {
  if (!outcome) {
    postDebugMsg(outcome, message);
    throw new AssertException(message);
  }
}

// Assumes an HTML list with id 'debug'
function postDebugMsg(outcome, message) {
  var debug = document.getElementById('debug');  
  var li = document.createElement('li');
  li.className = outcome ? 'pass' : 'fail';
  li.appendChild( document.createTextNode( message ) );
  debug.appendChild(li);
};

function AssertException(message) { this.message = message; }
AssertException.prototype.toString = function () {
  return 'AssertException: ' + this.message;
}

// === CONFIGURATION ==================================================
// Completely describes a game configuration
// This is interpreted to create the actual board game objects
// Alternatively, we will load the configuration from a JSON file ...
var config = {
  rows : 3,
  cols : 4,
  board : 'board12.png',
  piece1 : 'blue.png',
  piece2 : 'yellow.png',
  ladders : [
    { posn : 2, forward : 4 },
    { posn : 7, forward : 2 },
    { posn : 1, forward : -6 },
  ]
}

// === DISPLAY ==================================================
// display handles the painting of the board game
// it is a closure explosing only what is needed
// should we use MVC here?
var display; // = makeDisplay(config, jack, jill)
function makeDisplay(config, player1, player2) {
  var rows = config.rows;
  var cols = config.cols;
  var initialPosn = 1;
  var minPosn = 1;
  var maxPosn = rows * cols;

  var canvas = document.getElementById('display');
  var c = canvas.getContext('2d');

  var boardImg = new Image();
  boardImg.src = config.board;
  boardImg.onload = function () {
    c.canvas.height = this.naturalHeight;
    c.canvas.width = this.naturalWidth;
    c.drawImage(boardImg,0,0);
  };

  function rowHeight() { return c.canvas.height/rows; }
  function colWidth() { return c.canvas.width/cols; }
  function assertInRange(val, min, max, varname) {
    var msg = varname + ' ' + val + ' not in range [' + min + ',' + max + ']'
    assert( (min<=val) && (val<=max), msg);
  }
  // Row #1 is at the bottom
  function rowFor(posn) {
    assertInRange(posn, minPosn, maxPosn, 'position');
    return 1 + Math.floor((posn-1)/cols);
  }
  // Odd rows go left to right; even rows go right to left
  function colFor(posn) {
    assertInRange(posn, minPosn, maxPosn, 'position');
    var col = 1 + ((posn - 1) % cols);
    if ((rowFor(posn) % 2) == 0) {
      col = 1 + cols - col;
    }
    return col;
  }
  function posnFor(row, col) {
    assertInRange(row, 1, rows, 'row');
    assertInRange(col, 1, cols, 'col');
    return (row-1)*cols + (((row%2)==1) ? col : (1 + cols - col));
  }
  function testPositions() {
    var row, col, lastCol, posn2, msg;
    assert(posnFor(1,1) == 1, 'posnFor(1,1) = ' + posnFor(1,1) + ' (should be 1)')
    lastCol = ((rows%2)==0)?1:cols;
    assert(posnFor(rows,lastCol) == maxPosn, 'posnFor(' + rows + ',' + lastCol + ') = ' + posnFor(rows,lastCol) + ' (should be ' + maxPosn + ')')
    for (var posn=minPosn; posn<=maxPosn; posn++ ) {
      row = rowFor(posn);
      col = colFor(posn);
      posn2 = posnFor(row,col);
      msg = 'position ' + posn + ' != ' + 'posnFor(' + row + ',' + col + ') [=' + posn2 + ']'
      assert(posn == posn2, msg);
    }
  }
  
  function test() {
    testPositions();
  }

  var piece1, piece2;
  piece1 = new Image();
  piece1.src = config.piece1;
  piece1.offsetx = colWidth()/2;
  piece1.offsety = rowHeight()/4;
  piece1.posn = initialPosn;
  piece1.draw = function() {
    var row, col, dx, dy;
    row = rowFor(this.posn);
    col = colFor(this.posn);
    dx = colWidth() * (col-1) + this.offsetx;
    dy = rowHeight() * (rows-row) + this.offsety;
    c.drawImage(this,dx,dy,this.dw,this.dh);
  }
  piece1.move = function(posn) {
    this.posn = posn;
  }
  piece1.player = player1;
  piece1.onload = function () {
    var scale;
    this.player.piece = this;
    this.dh = rowHeight() / 2;
    scale = this.dh / this.naturalHeight;
    this.dw = this.naturalWidth * scale;
    repaint();
  }

  // strangely piece2 = Object.create(piece1) does not work

  piece2 = new Image();
  piece2.src = config.piece2;
  piece2.offsetx = colWidth()*3/4;
  piece2.offsety = piece1.offsety;
  piece2.posn = initialPosn;
  piece2.draw = piece1.draw;
  piece2.move= piece1.move;
  piece2.player = player2;
  piece2.onload = piece1.onload;

  function repaint() {
    c.drawImage(boardImg,0,0);
    piece1.draw();
    piece2.draw();
  }

  // only return the public fields
  return {
    repaint: repaint,
    test: test
  }
}

// display = makeDisplay(config, jack, jill);

// === SQUARES ==================================================
// The first square is the prototype for the others
var firstSquare = {
  posn : 1,
  landHere : function() {
    return this;
  },
  move : function move(moves) {
    return board.find(this.posn+moves).landHere();
  },
  isLastSquare : function() {
    return false;
  },
  // The first square does not care which players occupy it
  enter : function() {},
  leave : function() {}
}

// A plain square keeps track of who is on it
var plainSquare = Object.create(firstSquare);
plainSquare.player = null;
// If a player lands on an occupied square, he gets sent home
plainSquare.landHere = function() {
  if (this.player == null) {
    return this;
  } else {
    return board.home();
  }
}
plainSquare.enter = function(player) {
  this.player = player;
}
plainSquare.leave = function() {
  this.player = null;
}

var ladder = Object.create(plainSquare);
ladder.landHere = function() {
  return board.squares[this.posn + this.forward].landHere();
}

var lastSquare = Object.create(plainSquare);
lastSquare.isLastSquare = function() {
  return true;
}

// === BOARD CONFIGURATION ==================================================
// Configure this board
// We initialize the board to plain squares, and then replace the ladders
var board; // = makeBoard(config)
function makeBoard(config) {
  var squares = [];
  var square, newLadder;
  var size = config.rows * config.cols;
  // NB: start from 1, not 0, to make our life easier
  squares[1] = firstSquare;
  for (var i=2;i<=size;i++) {
    square = Object.create(plainSquare);
    squares[i] = square;
    square.posn = i;
  }
  var entry;
  for (i = 0; i<config.ladders.length; i++) {
    entry = config.ladders[i];
    newLadder = Object.create(ladder);
    newLadder.posn = entry.posn;
    newLadder.forward = entry.forward;
    squares[entry.posn] = newLadder;
  }
  
  squares[size] = lastSquare;
  lastSquare.posn = size;
  
  var find = function(posn) {
    assert(posn>0 && posn<(2*this.size));
    if (posn>this.size) {
      posn = this.size - (posn-this.size);
    }
    return this.squares[posn]
  }
  var home = function() {
    return this.squares[1]; // firstSquare
  }
  return {
    size : size,
    squares : squares,
    find : find,
    home : home
  }
}

// board = makeBoard(config);

// === PLAYERS ==================================================
// Jack is Jill's prototype
var jack, jill;
jack = {
  name : 'Jack',
  // piece : display.piece1,
  square : firstSquare,
  move : function(moves) {
    this.square.leave();
    this.square = this.square.move(moves);
    this.piece.posn = this.square.posn;
    this.square.enter(this);
    display.repaint();
  },
  wins : function() {
    return this.square.isLastSquare();
  }
}

jill = Object.create(jack);
jill.name = 'Jill';
// jill.piece = display.piece2;
jill.square = firstSquare;

// === DIE ==================================================
var die = {
  roll : function() {
    return 1 + Math.floor(6*Math.random());
  }
}

// === GAME LOGIC ==================================================
// The game logic; a literal object
var game = {
  player : jack,
  isOver : false,
  swapTurn : function () {
    this.player = (this.player === jack) ? jill : jack;
  },
  move : function () {
    var moves;
    var win = '';
    if (!this.isOver) {
      moves = die.roll();
      this.player.move(moves);
      if (this.player.wins()) {
        win = ' &mdash; ' + this.player.name + ' wins!'
        this.isOver = true;
      }
      this.status(this.player.name + ' rolls ' + moves + win);
      this.swapTurn();
    } else {
      this.status('The game is over!');
    }
  },
  status : function(msg) {
    document.getElementById('status').innerHTML=msg;
  }
}

// === NEW GAME ==================================================
// to be called from the main HTML file
function newGame(config) {
  board = makeBoard(config);
  jack.square = firstSquare;
  jill.square = firstSquare;
  game.player = jack;
  game.isOver = false;
  display = makeDisplay(config, jack, jill);
  display.test();
  display.repaint();
}

// === END ==================================================
