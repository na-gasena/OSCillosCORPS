class MidiControl{
    String midiTrack = "Debussy_amairo.mid"; // filename in /data folder
    int midiTranspose = -1; // shift key of midi track
    float midiBPM = 110;

    // MIDI details
    Sequencer sequencer;
    Sequence sequence;
    
    class MidiReceiver implements Receiver {
        void close() { }
        
        void send(MidiMessage msg, long timeStamp) {
            if (msg instanceof ShortMessage) {
                ShortMessage sm = (ShortMessage)msg;
                if (sm.getCommand() == ShortMessage.NOTE_ON) {
                    int note = sm.getData1();
                    int vel  = sm.getData2();
                    //xy.amp(map(vel, 0, 127, 0, 1));
                    xy.freq(Frequency.ofMidiNote(note + (midiTranspose * 12)).asHz());
                    xy.resetWaves();
                }
            }
        }
    }
    
    void setupMidi(String midiFile) {
        // load midi
        try {
            sequencer = MidiSystem.getSequencer(false);
            sequencer.open();
            sequence = MidiSystem.getSequence(createInput(midiFile));
            sequencer.setSequence(sequence);
            sequencer.setTempoInBPM(midiBPM);
            sequencer.getTransmitter().setReceiver(new MidiReceiver());
            sequencer.setLoopCount(Sequencer.LOOP_CONTINUOUSLY);
            sequencer.start();
        } catch(MidiUnavailableException ex) {
            // no sequencer
            println("No default sequencer, sorry bud.");
        } catch(InvalidMidiDataException ex) {
            // oops, the file was bad
            println("The midi file was hosed or not a midi file, sorry bud.");
        } catch(IOException ex) {
            println("Had a problem accessing the midi file, sorry bud.");
        }
    }
    
}
