function settocsv(directory, filename)
  EEG = pop_loadset(filename, directory);
  csvwrite(strcat(filename, '.csv'), EEG.data);
end
