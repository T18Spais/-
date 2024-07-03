// Εκκίνηση του διακομιστή ήχου
s.boot;

// SynthDef για απλό ηχητικό κύμα με ηχώ
(
SynthDef(\echo_sine, { |freq = 440, amp = 0.1, dur = 1|
    var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
    var osc = SinOsc.ar(freq, 0, amp * env);
    var echo = CombN.ar(osc, 0.3, 0.3, 3); // Ηχώ
    Out.ar(0, echo ! 2);
}).add;
)

// SynthDef για θόρυβο με φίλτρο
(
SynthDef(\filtered_noise, { |amp = 0.1, dur = 1|
    var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
    var noise = WhiteNoise.ar(amp * env);
    var filter = LPF.ar(noise, 800); // Χαμηλοπερατό φίλτρο
    Out.ar(0, filter ! 2);
}).add;
)

// Παράδειγμα χρήσης της σύνθεσης με Pbind για το echo_sine
(
Pbind(
    \instrument, \echo_sine,
    \freq, Pseq([440, 550, 660, 770, 880], inf),
    \dur, 0.5,
    \amp, 0.1
).play;
)

// Παράδειγμα χρήσης της σύνθεσης με Pbind για το filtered_noise
(
Pbind(
    \instrument, \filtered_noise,
    \dur, 1,
    \amp, 0.1
).play;
)

// Συνδυασμός των δύο SynthDef με Ppar για ταυτόχρονη αναπαραγωγή
(
Ppar([
    Pbind(
        \instrument, \echo_sine,
        \freq, Pseq([440, 550, 660, 770, 880], inf),
        \dur, 0.5,
        \amp, 0.1
    ),
    Pbind(
        \instrument, \filtered_noise,
        \dur, 1,
        \amp, 0.1
    )
]).play;
)
