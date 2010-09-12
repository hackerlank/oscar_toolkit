/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.oscar.javaserialize.externalizable;

import java.io.Externalizable;
import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectOutput;

/**
 *
 * @author oscar
 */
public class Item implements Externalizable {

    private long id;
    private int type;
    private long addTime;
    private int[] attr = new int[10];

    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        id = in.readLong();
        type = in.readInt();
        addTime = in.readLong();
        for (int i = 0; i < 10; ++i) {
            attr[i] = in.readInt();
        }
    }

    public void writeExternal(ObjectOutput out) throws IOException {
        out.writeLong(id);
        out.writeInt(type);
        out.writeLong(addTime);
        for (int i = 0; i < 10; ++i) {
            out.writeInt(attr[i]);

        }
    }

    public long getAddTime() {
        return addTime;
    }

    public void setAddTime(long addTime) {
        this.addTime = addTime;
    }

    public int[] getAttr() {
        return attr;
    }

    public void setAttr(int[] attr) {
        this.attr = attr;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }
}
