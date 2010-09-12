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
public class Quest implements Externalizable {

    private long id;
    private int type;
    private int status;
    private long add_time;

    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        id = in.readLong();
        type = in.readInt();
        status = in.readInt();
        add_time = in.readLong();
    }

    public void writeExternal(ObjectOutput out) throws IOException {
        out.writeLong(id);
        out.writeInt(type);
        out.writeInt(status);
        out.writeLong(add_time);
    }

    public long getAdd_time() {
        return add_time;
    }

    public void setAdd_time(long add_time) {
        this.add_time = add_time;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }
}
