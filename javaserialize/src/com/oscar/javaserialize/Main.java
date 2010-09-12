/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.oscar.javaserialize;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

/**
 * @see http://www.infoq.com/news/2006/11/serialization-optimization
 * @see http://www.javalobby.org/forums/thread.jspa?messageID=92059245
 * @see http://www.javalobby.org/java/forums/t88856.html?start=0
 * 
 * Cameron Purdy comments:
 * 
 * Java Serialization has its problems, mainly related to size (of the resulting binary),
 * performance (which is relatively poor) and portability (since it is only portable inside the Java universe).
 * However, if you are dealing with persistence of objects, moving them off the heap,
 * or streaming them among VMs, then Java serialization is a good general-purpose solution in Java.
 * 
 * @author oscar
 */
public class Main {

    private final int TIMES = 10000;
    private long serializeTime = 0;
    private long deserializeTime = 0;

    public long getDeserializeTime() {
        return deserializeTime;
    }

    public void setDeserializeTime(long deserializeTime) {
        this.deserializeTime = deserializeTime;
    }

    public long getSerializeTime() {
        return serializeTime;
    }

    public void setSerializeTime(long serializeTime) {
        this.serializeTime = serializeTime;
    }

    public static void main(String[] args) throws IOException, ClassNotFoundException {
        for (int i = 0; i < 10; ++i) {
            com.oscar.javaserialize.serializable.Role sp = new com.oscar.javaserialize.serializable.Role();
            Main m = new Main();
            m.benchmark(sp);
            System.out.println("S1: serializeTime: " + m.getSerializeTime() + " deserializeTime: " + m.getDeserializeTime());
            //
            com.oscar.javaserialize.externalizable.Role role = new com.oscar.javaserialize.externalizable.Role();
            m = new Main();
            m.benchmark(role);
            System.out.println("S2: serializeTime: " + m.getSerializeTime() + " deserializeTime: " + m.getDeserializeTime());
        }
    }

    public void benchmark(Object o) throws IOException, ClassNotFoundException {
        long start = 0;
        long middle = 0;
        for (int i = 0; i < TIMES; ++i) {
            start = System.currentTimeMillis();
            ByteArrayOutputStream bout = new ByteArrayOutputStream();
            ObjectOutputStream out = new ObjectOutputStream(bout);
            out.writeObject(o);
            out.close();
            middle = System.currentTimeMillis();
            //
            ByteArrayInputStream bin = new ByteArrayInputStream(bout.toByteArray());
            ObjectInputStream in = new ObjectInputStream(bin);
            in.readObject();
            in.close();
            deserializeTime += System.currentTimeMillis() - middle;
            serializeTime += middle - start;
        }
    }

    public void test() throws IOException, ClassNotFoundException {
        com.oscar.javaserialize.externalizable.Role role = new com.oscar.javaserialize.externalizable.Role();
        role.setId(1000L);
        role.setLevel(10);
        role.setMoney(9898);
        role.setName("fcuk");
        //
        ByteArrayOutputStream bout = new ByteArrayOutputStream();
        ObjectOutputStream out = new ObjectOutputStream(bout);
        out.writeObject(role);
        out.close();
        //
        ByteArrayInputStream bin = new ByteArrayInputStream(bout.toByteArray());
        ObjectInputStream in = new ObjectInputStream(bin);
        com.oscar.javaserialize.externalizable.Role actual = (com.oscar.javaserialize.externalizable.Role) in.readObject();
        in.close();
        assert actual.getId() == role.getId();
        assert actual.getName().equals(role.getName());
    }
}
