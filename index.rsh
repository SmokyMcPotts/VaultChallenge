'reach 0.1';

const COUNTDOWN = 20;

const shared = {
  showCountdown: Fun([UInt], Null),
};

export const main = Reach.App(() => {
  const A = Participant('Alice', {
    // Specify Alice's interact interface here
    ...shared,
    inherit: UInt,
    getChoice: Fun([], Bool),
  });
  const B = Participant('Bob', {
    // Specify Bob's interact interface here
    ...shared,
    acceptTerms: Fun([UInt], Bool),
  });
  init();
  
  // The first one to publish deploys the contract
  A.only(() => {
    const value = declassify(interact.inherit);
  });
  A.publish(value)
    .pay(value);
  commit();
  
  // The second one to publish always attaches
  B.only(() => {
    const terms = declassify(interact.acceptTerms(value));
  })
  B.publish(terms);
  commit();

  // write your program here
  each([A, B], () => {
    interact.showCountdown(COUNTDOWN);
  })
  
A.only(() => {
  const stillHere = declassify (interact.getChoice());
})
A.publish(stillHere)

if (stillHere) {
  transfer(value).to(A);
} else {
  transfer(value).to(B);
}
commit();

exit();

});
