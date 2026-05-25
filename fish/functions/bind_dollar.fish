function bind_dollar
    if commandline -t | string match -q '!'
        commandline -t ""
        commandline -i (commandline -p | string split ' ')[-1]
    else
        commandline -i '$'
    end
end
