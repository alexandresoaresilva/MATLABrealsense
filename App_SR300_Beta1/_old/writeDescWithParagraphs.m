%40 characeters fit per line
function cellArrayWithParagraphs = writeDescWithParagraphs(optionCellString,wordsPerLine) 
    stringArray = char(optionCellString);
    numOfSpaces = 0;
    stringList = strings

    word=char.empty(1,0)

    
    j = 1;
    for i = 1:length(stringArray)
        if stringArray(i) == ' '
            numOfSpaces = numOfSpaces + 1;
            if ~isempty(word)
                stringList(numOfSpaces)= string(word);
            end
            clear word;
            word=char.empty(1,0);%recreates word
            j = 1; %restarts index for word
            while(i+1) == ' '
                i = i + 1;
            end
        else
            word(j)=stringArray(i);
            j = j + 1; %index for word only
        end
    end
    stringWithParagraphs = strings;



    for i = 1:length(stringList)
       stringWithParagraphs = strcat(stringWithParagraphs,stringList(i));

        if rem(i,wordsPerLine) ~= 0 %3 is the number of words per line
            stringWithParagraphs = strcat(stringWithParagraphs,{' '})
        else
            if i ~= length(stringList)
                stringWithParagraphs = strcat(stringWithParagraphs,{newline})
            end
        end

    end

    cellArrayWithParagraphs = cellstr(stringWithParagraphs)
end