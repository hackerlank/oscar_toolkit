/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.oscar.javaserialize.serializable;

import java.io.Serializable;

/**
 *
 * @author oscar
 */
public class Quest implements Serializable {

    private long id;
    private int type;
    private int status;
    private long add_time;

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
