/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.oscar.javaserialize.externalizable;

import java.io.Externalizable;
import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectOutput;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author oscar
 */
public class Role implements Externalizable {

    private long id;
    private String name = "hellworld";
    private int level;
    private int money;
    private List<Quest> quests = new ArrayList<Quest>();
    private List<Item> items = new ArrayList<Item>();

    public Role() {
        for (int i = 0; i < 50; ++i) {
            quests.add(new Quest());
        }
        for (int i = 0; i < 100; ++i) {
            items.add(new Item());
        }
    }

    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        id = in.readLong();
        name = in.readUTF();
        level = in.readInt();
        money = in.readInt();
        int questCount = in.readInt();
        for (int i = 0; i < questCount; ++i) {
            quests.add((Quest) in.readObject());
        }
        int itemCount = in.readInt();
        for (int i = 0; i < itemCount; ++i) {
            items.add((Item) in.readObject());
        }
    }

    public void writeExternal(ObjectOutput out) throws IOException {
        out.writeLong(id);
        out.writeUTF(name);
        out.writeInt(level);
        out.writeInt(money);
        out.writeInt(quests.size());
        for (Quest e : quests) {
            out.writeObject(e);
        }
        out.writeInt(items.size());
        for (Item e : items) {
            out.writeObject(e);
        }
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public List<Item> getItems() {
        return items;
    }

    public void setItems(List<Item> items) {
        this.items = items;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public int getMoney() {
        return money;
    }

    public void setMoney(int money) {
        this.money = money;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<Quest> getQuests() {
        return quests;
    }

    public void setQuests(List<Quest> quests) {
        this.quests = quests;
    }
}
