function deploy_mbtiles() {
  # step 1: validate *.mbtiles ... proper size, etc...
  # if []; then
  # fi

  # step 2: bolt_reload.sh - deploy new *.mbtiles server to remote (staging / production) servers via 'bolt'
  #$DIR/bolt_reload.sh

  # step 3: bolt_restart.sh - restart remote servers after new *.mbtiles are deployed there
  # maybe tileserver-gl can have different font (or other static) files to identify BLUE / GREEN server

  # step 4: bolt_clear.sh   - that tileserver-gl is up and responding on remote servers, then clear file (tile) cache
}


echo DEPLOY 
echo TODO
