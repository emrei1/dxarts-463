// Emre Inceoglu - DXARTS 463 Assignment 1

Server.killAll;

MIDIIn.connectAll;

(
s.options.numBuffers_(4096);
s.options.memSize_(2**21);
s.boot;

~audioBus = CtkAudio.new(2);


~synth = CtkSynthDef(\default, {arg out = 0, freq = 440, amp = 0.5, pan = 0;
    var snd, env;
    snd = SinOsc.ar(freq, 0, amp);
    env = EnvGen.kr(Env.perc, doneAction: 2);
    Out.ar(out, Pan2.ar(snd * env, pan));
});

~reverb = CtkSynthDef('reverb', {arg in = 0, out;
    var snd, env;
    snd = In.ar(in, 2);
    Out.ar(out, FreeVerb.ar(snd, 0.75, 0.74));
});
)

(
~lfoWaits1 = CtkControl.lfo(LFNoise2, 0.5, 0.1, 0.7).play;
~lfoFreqs1 = CtkControl.lfo(LFNoise2, 0.15, 36, 16).play;
~lfoAmps1 = CtkControl.lfo(LFNoise2, 0.15, 0.3, 0.37).play;
~lfoPans1 = CtkControl.lfo(LFNoise2, 0.15, -1, 1).play;
~lfoNumHarms1 = CtkControl.lfo(LFNoise2, 0.15, 1, 50).play;
~task1 = Task({
    loop({
        var wait, freq, amp, pan, numHarms;
        freq =
		~lfoFreqs1.getSynchronous;
        wait = ~lfoWaits1.getSynchronous;
        amp = ~lfoAmps1.getSynchronous;
        pan = ~lfoPans1.getSynchronous;
        numHarms = ~lfoNumHarms1.getSynchronous;
        numHarms.do{arg harmonic;
            ~synth.note
            .freq_(freq.asInt.midicps * (harmonic+1))
            .amp_(amp * ((harmonic+1).reciprocal))
            .pan_(pan)
            .out_(~audioBus).play;
        };
        wait.wait;
    });
});
)

(
~lfoWaits2 = CtkControl.lfo(LFNoise2, 0.5, 1, 5).play;
~lfoFreqs2 = CtkControl.lfo(LFNoise2, 0.15, 50, 75).play;
~lfoAmps2 = CtkControl.lfo(LFNoise2, 0.15, 0.1, 0.4).play;
~lfoPans2 = CtkControl.lfo(LFNoise2, 0.15, -1, 1).play;
~lfoNumHarms2 = CtkControl.lfo(LFNoise2, 0.15, 1, 150).play;
~task2 = Task({
    loop({
        var wait, freq, amp, pan, numHarms;
        freq =
		~lfoFreqs2.getSynchronous;
        wait = ~lfoWaits2.getSynchronous;
        amp = ~lfoAmps2.getSynchronous;
        pan = ~lfoPans2.getSynchronous;
        numHarms = ~lfoNumHarms2.getSynchronous;
        numHarms.do{arg harmonic;
            ~synth.note
            .freq_(freq.asInt.midicps * (harmonic+1))
            .amp_(amp * ((harmonic+1).reciprocal))
            .pan_(pan)
            .out_(~audioBus).play;
        };
        wait.wait;
    });
});
)

(
~lfoWaits3 = CtkControl.lfo(LFNoise2, 0.5, 1, 2).play;
~lfoFreqs3 = CtkControl.lfo(LFNoise2, 0.15, 50, 75).play;
~lfoAmps3 = CtkControl.lfo(LFNoise2, 0.15, 0.1, 0.3).play;
~lfoPans3 = CtkControl.lfo(LFNoise2, 0.15, -1, 1).play;
~lfoNumHarms3 = CtkControl.lfo(LFNoise2, 0.15, 1, 150).play;
~task3 = Task({
    loop({
        var wait, freq, amp, pan, numHarms;
        freq =
		~lfoFreqs3.getSynchronous;
        wait = ~lfoWaits3.getSynchronous;
        amp = ~lfoAmps3.getSynchronous;
        pan = ~lfoPans3.getSynchronous;
        numHarms = ~lfoNumHarms3.getSynchronous;
        numHarms.do{arg harmonic;
            ~synth.note
            .freq_(freq.asInt.midicps * (harmonic+1))
            .amp_(amp * ((harmonic+1).reciprocal))
            .pan_(pan)
            .out_(~audioBus).play;
        };
        wait.wait;
    });
});
)

(
var firstNoteOffset;
var firstNoteStopOffset;
var stopOffsetIncrement;
var arrayOfTasks;
firstNoteOffset = 48; // C2 will start task1, C2# will start task2, D2 will start task3
stopOffsetIncrement = 5;
firstNoteStopOffset = firstNoteOffset + stopOffsetIncrement; // F2 will stop task1, F2# will stop task2, G2 will stop task3
arrayOfTasks = arrayOfTasks.add(~task1);
arrayOfTasks = arrayOfTasks.add(~task2);
arrayOfTasks = arrayOfTasks.add(~task3);

	~noteOn = NoteOnResponder({ |src, chan, note, vel|
		~reverb.note.in_(~audioBus).out_(0).play;
		arrayOfTasks[note-firstNoteOffset].play;
		if (note >= firstNoteStopOffset, {
		    "stopped playing task".postln;
		    arrayOfTasks[note-firstNoteStopOffset].stop;
	    });
	},
    nil,
    nil,
    nil,
    nil
    );
	~noteOff = NoteOffResponder({ |src,chan,note,vel|
		//arrayOfTasks[note-firstNoteOffset].stop;
	    //arrayOfTasks[note-firstNoteOffset].reset;
    },
    nil,
    nil,
    nil,
    nil
    );
	CmdPeriod.doOnce({
        ~noteOn.free;
        ~noteOff.free;
    })
)

~reverb.note.in_(~audioBus).out_(0).play;
~task1.stop;
~task2.stop;
~task3.stop;

~task1.reset;
~task2.reset;
~task3.reset;

Server.freeAll;
s.boot;


// GRADE //

// 10


