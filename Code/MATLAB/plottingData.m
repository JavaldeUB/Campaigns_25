
figure;plot(resultados_MXA(:,1))
hold on;plot(resultados_MXA(:,2),'r')
hold on;plot(resultados_MXA(:,3),'k')
hold on;plot(resultados_MXA(resultados_MXA(:,4)<=200,4),'g')
xlabel("t(s)")
ylabel("Resistance (k\Omega)")
xlim([0 length(resultados_MXA)])
legend

figure;plot(resultados_MXD(:,1))
hold on;plot(resultados_MXD(:,2),'r')
hold on;plot(resultados_MXD(:,3),'k')
hold on;plot(resultados_MXD(:,4),'g')
hold on;plot(resultados_MXD(:,6),'m')
hold on;plot(resultados_MXD(:,7),'y')
xlim([0 length(resultados_MXD)])
xlabel("t(s)")
ylabel("Resistance (k\Omega)")
legend

figure;plot(resultados_MXD(:,8))
xlabel("t(s)")
xlim([0 length(resultados_MXD)])
ylabel("CO_{2} (ppm)")

figure;plot(resultados_ECS(:,1))
hold on;plot(resultados_ECS(:,2),'r')
hold on;plot(resultados_ECS(:,3),'k')
xlabel("t(s)")
ylabel("Gas Concentration (ppm)")
xlim([0 length(resultados_ECS)])
legend

figure;plot(resultados_ECS(:,5))
xlabel("t(s)")
ylabel("PID Concentration (ppm)")
xlim([0 length(resultados_ECS)])