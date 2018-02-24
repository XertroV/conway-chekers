mkdir _dist
yarn run elm-make src/Main.elm --output _dist/elm.js
cp checkers.html _dist/index.html
cp -a js _dist/js
