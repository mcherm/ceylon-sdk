import ceylon.buffer {
    ByteBuffer
}
import ceylon.buffer.readers {
    Reader
}
import ceylon.io {
    FileDescriptor
}

"Reader that can read from a [[FileDescriptor]].
 
 If [[length]] is specified, this reader will read at most 
 [[length]] bytes until it considers that it reached end of 
 file."
by("Stéphane Épardaud")
shared class FileDescriptorReader(fileDescriptor, 
    Integer? length = null) 
        extends Reader() {
    
    shared FileDescriptor fileDescriptor;
    
    variable Integer position = 0;
    
    "Reads data into the specified [[buffer]] and return the number
     of bytes read, or `-1` if the end of file is reached."
    shared actual Integer read(ByteBuffer buffer) {
        if(exists length) {
            // check that we didn't already read it all
            if(position == length) {
                return -1;
            }
            // maybe decrease the max to read from the buffer if required
            Integer remaining = length - position;
            if(buffer.available > remaining) {
                buffer.limit = buffer.position + remaining;
            }
        }
        Integer r = fileDescriptor.read(buffer);
        if(r == -1) {
            return r;
        }
        position += r;
        return r;
    }

}
