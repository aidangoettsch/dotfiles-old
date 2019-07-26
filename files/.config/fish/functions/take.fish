function take --description "Create a directory and change into it"
  if [ (count $argv) -eq 1 ]
    mkdir $argv
    cd $argv
  else
    echo "Enter a directory name"
  end
end
