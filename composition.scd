// Εκκίνηση του διακομιστή ήχου
s.boot;

// SynthDef για σύνθετο ηχητικό κύμα με πολλαπλά εφέ
(
SynthDef(\complex_wave, { |freq = 440, amp = 0.1, dur = 1|
    var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
    var osc1 = SinOsc.ar(freq, 0, amp * env);
    var osc2 = Saw.ar(freq * 1.5, amp * 0.5 * env);
    var osc3 = Pulse.ar(freq * 0.5, 0.4, amp * 0.3 * env);
    var mix = Mix.new([osc1, osc2, osc3]);
    var filter = RLPF.ar(mix, freq * LFNoise1.kr(1).range(0.5, 2), 0.2);
    var reverb = FreeVerb.ar(filter, 0.5, 0.9, 0.8);
    var delay = CombN.ar(reverb, 0.3, 0.3, 3);
    Out.ar(0, delay ! 2);
}).add;
)

// SynthDef για θόρυβο με διαφορετικά φίλτρα και modulation
(
SynthDef(\filtered_noise_complex, { |amp = 0.1, dur = 1|
    var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
    var noise = WhiteNoise.ar(amp * env);
    var filter1 = RLPF.ar(noise, 500 * LFNoise1.kr(1).range(1, 5), 0.2);
    var filter2 = BPF.ar(noise, 2000 * LFNoise0.kr(0.5).range(0.5, 2), 0.1);
    var mix = Mix.new([filter1, filter2]);
    var reverb = FreeVerb.ar(mix, 0.3, 0.7, 0.9);
    Out.ar(0, reverb ! 2);
}).add;
)

// SynthDef για παλμό με modulation και φίλτρο
(
SynthDef(\pulse_wave, { |freq = 440, amp = 0.1, width = 0.5, dur = 1|
    var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
    var pulse = Pulse.ar(freq, width, amp * env);
    var filter = BPF.ar(pulse, freq * 2, 0.1);
    var ringMod = Ringz.ar(filter, freq * 1.5, 0.2);
    var reverb = FreeVerb.ar(ringMod, 0.4, 0.8, 0.6);
    Out.ar(0, reverb ! 2);
}).add;
)

// Παράδειγμα χρήσης της σύνθεσης με Pbind για το complex_wave
(
Pbind(
    \instrument, \complex_wave,
    \freq, Pseq([330, 440, 550, 660, 770], inf),
    \dur, Pseq([0.5, 0.75, 1, 1.25, 1.5], inf),
    \amp, 0.2
).play;
)

// Παράδειγμα χρήσης της σύνθεσης με Pbind για το filtered_noise_complex
(
Pbind(
    \instrument, \filtered_noise_complex,
    \dur, Pseq([1, 1.5, 2, 2.5], inf),
    \amp, 0.15
).play;
)

// Παράδειγμα χρήσης της σύνθεσης με Pbind για το pulse_wave
(
Pbind(
    \instrument, \pulse_wave,
    \freq, Pseq([110, 220, 330, 440, 550], inf),
    \dur, Pseq([0.25, 0.5, 0.75, 1], inf),
    \amp, 0.1,
    \width, Pseq([0.1, 0.3, 0.5, 0.7, 0.9], inf)
).play;
)

// Συνδυασμός των τριών SynthDef με Ppar για ταυτόχρονη αναπαραγωγή
(
Ppar([
    Pbind(
        \instrument, \complex_wave,
        \freq, Pseq([330, 440, 550, 660, 770], inf),
        \dur, Pseq([0.5, 0.75, 1, 1.25, 1.5], inf),
        \amp, 0.2
    ),
    Pbind(
        \instrument, \filtered_noise_complex,
        \dur, Pseq([1, 1.5, 2, 2.5], inf),
        \amp, 0.15
    ),
    Pbind(
        \instrument, \pulse_wave,
        \freq, Pseq([110, 220, 330, 440, 550], inf),
        \dur, Pseq([0.25, 0.5, 0.75, 1], inf),
        \amp, 0.1,
        \width, Pseq([0.1, 0.3, 0.5, 0.7, 0.9], inf)
    )
]).play;
)
