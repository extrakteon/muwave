function [err, Jac] = ErrFun(x, GL, Tone, dio, ModNum, Step)

if (x(1) < -1) || (x(1) > 1) || (x(2) < -1) || (x(2) > 1)
    disp('ERROR');
    err = [0 0];
    Jac = [0 0; 0 0];
else
    % Set the IQ modulator in the point of interest
    SetIQRec(x(1), x(2), dio, ModNum);
    % Measure lsna
    lsna_measure;
    % read measurement data
    a20 = lsna_read_data('a2');
    b20 = lsna_read_data('b2');
    Gamma0 = a20(Tone)./b20(Tone);

    % Calculate the Jacobian
    % set step length
    dx = -sign(x(1)).*Step + (x(1) == 0).*Step;
    dy = -sign(x(2)).*Step + (x(2) == 0).*Step;

    % measure dx
    SetIQRec(x(1)+dx, x(2), dio, ModNum);
    lsna_measure;
    % read measurement data
    a2dx = lsna_read_data('a2');
    b2dx = lsna_read_data('b2');
    Gammadx = a2dx(Tone)./b2dx(Tone);

    % measure dy
    SetIQRec(x(1), x(2)+dy, dio, ModNum);
    lsna_measure;
    % read measurement data
    a2dy = lsna_read_data('a2');
    b2dy = lsna_read_data('b2');
    Gammady = a2dy(Tone)./b2dy(Tone);

    Jac11 = real((Gammadx - Gamma0))./dx;
    Jac12 = real((Gammady - Gamma0))./dy;
    Jac21 = imag((Gammadx - Gamma0))./dx;
    Jac22 = imag((Gammady - Gamma0))./dy;

    Jac = [Jac11, Jac12; Jac21, Jac22]; % the jacobian

    % Calculate the error
    Rerr = real(Gamma0) - real(GL);
    Ierr = imag(Gamma0) - imag(GL);
    err = [Rerr Ierr];
end