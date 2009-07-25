def extend_load_paths(src_file_name)
  unless src_file_name.nil?
    req_dir_name     = File.dirname(src_file_name)
    req_abs_dir_name = File.expand_path(req_dir_name)

    unless $LOAD_PATH.include?(req_dir_name) or
             $LOAD_PATH.include?(req_abs_dir_name) then
      $LOAD_PATH.unshift(req_dir_name)
    end
  end
end