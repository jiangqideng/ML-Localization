function traces = getRandomTraces( roomLength, roomWidth, t, n_obj )
%getRandomTrace get random traces of multi objects in a room
    traces = zeros(t, 2, n_obj);
    for i = 1 : n_obj
        traces(:, :, i) = getRandomTrace(roomLength, roomWidth, t);
    end
end

