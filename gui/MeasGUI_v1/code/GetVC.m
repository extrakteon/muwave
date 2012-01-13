function VC = GetVC(PIN,FIT)
VC = FIT(1)*PIN.^2 + FIT(2)*PIN + FIT(3);