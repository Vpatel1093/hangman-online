#theodinproject.com/ruby-programming/file-i-o-and-serialization?ref=lnav


<p>You will be building a simple command line Hangman game where one player plays against the computer, but a bit more advanced.  If you&#39;re unfamiliar with how Hangman works, see <a href="http://en.wikipedia.org/wiki/Hangman_(game)">Wikipedia</a>.</p>

<ol>
<li>Download the <code>5desk.txt</code> dictionary file from <a href="http://scrapmaker.com/view/twelve-dicts/5desk.txt">http://scrapmaker.com/</a>.</li>
<li>When a new game is started, your script should load in the dictionary and randomly select a word between 5 and 12 characters long for the secret word.</li>
<li>You don&#39;t need to draw an actual stick figure (though you can if you want to!), but do display some sort of count so the player knows how many more incorrect guesses she has before the game ends.  You should also display which correct letters have already been chosen (and their position in the word, e.g. <code>_ r o g r a _ _ i n g</code>) and which incorrect letters have already been chosen.</li>
<li>Every turn, allow the player to make a guess of a letter.  It should be case insensitive.  Update the display to reflect whether the letter was correct or incorrect.  If out of guesses, the player should lose.</li>
<li>Now implement the functionality where, at the start of any turn, instead of making a guess the player should also have the option to save the game.  Remember what you learned about serializing objects... you can serialize your game class too!</li>
<li>When the program first loads, add in an option that allows you to open one of your saved games, which should jump you exactly back to where you were when you saved.  Play on!</li>
