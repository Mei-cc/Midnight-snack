package com.midnightsnack.controller;

import com.midnightsnack.entity.CartItem;
import com.midnightsnack.entity.User;
import com.midnightsnack.service.CartItemService;
import com.midnightsnack.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 购物车控制器
 */
@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartItemService cartItemService;

    /**
     * 添加商品到购物车
     */
    @PostMapping("/add")
    @ResponseBody
    public Result<CartItem> addToCart(@RequestParam Integer productId,
                                       @RequestParam(required = false, defaultValue = "1") Integer quantity,
                                       HttpSession session) {
        // 检查登录状态
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("请先登录");
        }

        return cartItemService.addToCart(user.getId(), productId, quantity);
    }

    /**
     * 获取购物车列表
     */
    @GetMapping("/list")
    @ResponseBody
    public Result<List<CartItem>> getCartList(HttpSession session) {
        // 检查登录状态
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("请先登录");
        }

        return cartItemService.getCartItems(user.getId());
    }

    /**
     * 更新商品数量
     */
    @PostMapping("/update")
    @ResponseBody
    public Result<Void> updateQuantity(@RequestParam Integer cartItemId,
                                        @RequestParam Integer quantity,
                                        HttpSession session) {
        // 检查登录状态
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("请先登录");
        }

        return cartItemService.updateQuantity(cartItemId, quantity, user.getId());
    }

    /**
     * 删除购物车项
     */
    @PostMapping("/remove")
    @ResponseBody
    public Result<Void> removeCartItem(@RequestParam Integer cartItemId,
                                         HttpSession session) {
        // 检查登录状态
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("请先登录");
        }

        return cartItemService.removeCartItem(cartItemId, user.getId());
    }

    /**
     * 批量删除购物车项
     */
    @PostMapping("/removeMultiple")
    @ResponseBody
    public Result<Void> removeMultipleCartItems(@RequestBody List<Integer> cartItemIds,
                                                  HttpSession session) {
        // 检查登录状态
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("请先登录");
        }

        return cartItemService.removeMultipleCartItems(cartItemIds, user.getId());
    }

    /**
     * 清空购物车
     */
    @PostMapping("/clear")
    @ResponseBody
    public Result<Void> clearCart(HttpSession session) {
        // 检查登录状态
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("请先登录");
        }

        return cartItemService.clearCart(user.getId());
    }

    /**
     * 获取购物车商品数量
     */
    @GetMapping("/count")
    @ResponseBody
    public Result<Integer> getCartCount(HttpSession session) {
        // 检查登录状态
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.success(0);
        }

        return cartItemService.getCartCount(user.getId());
    }
}
