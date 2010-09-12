/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.oscar.javaserialize.serializable;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author oscar
 */
public class Role implements Serializable {

    private long id;
    private String name;
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
