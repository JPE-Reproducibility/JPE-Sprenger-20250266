function V=RDEU(P,X,u,pi,a,g)

% Order from above
[X_ordered,order]=sort(X,'descend');

% Utility
V=sum([pi(P(order(1)),g),pi(P(order(2))+P(order(1)),g)-pi(P(order(1)),g),1-pi(P(order(2))+P(order(1)),g)].*u(X_ordered,a));

end



