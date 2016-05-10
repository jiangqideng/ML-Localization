function dist = f_squareform( dist )
    len = length(dist);
    tmp = [];
    for i = 1 : len
        for j = 1 : len
            if j > i
                tmp = [tmp, dist(j, i)];
            end
        end
    end
    dist = tmp;
end

