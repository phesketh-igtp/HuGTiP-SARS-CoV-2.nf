process combineDepth {
    
  label "artic"
  cpus 1
  input:
    path "depth_stats/*"
  output:
    file "all_depth.txt"
  script:
  """
    header_file=`ls depth_stats/* | head -1`
    head -1 \${header_file} > all_depth.txt
    cat depth_stats/* | grep -v depth_fwd >> all_depth.txt
  """
}