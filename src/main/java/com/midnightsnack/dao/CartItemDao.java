package com.midnightsnack.dao;

import com.midnightsnack.entity.CartItem;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 购物车数据访问接口
 */
public interface CartItemDao {

    /**
     * 插入购物车项
     * @param cartItem 购物车项
     * @return 影响行数
     */
    int insert(CartItem cartItem);

    /**
     * 根据ID查询购物车项
     * @param id 购物车项ID
     * @return 购物车项
     */
    CartItem selectById(Integer id);

    /**
     * 根据用户ID和商品ID查询购物车项
     * @param userId 用户ID
     * @param productId 商品ID
     * @return 购物车项
     */
    CartItem selectByUserIdAndProductId(@Param("userId") Integer userId, @Param("productId") Integer productId);

    /**
     * 查询用户的购物车列表（包含商品信息）
     * @param userId 用户ID
     * @return 购物车项列表
     */
    List<CartItem> selectByUserId(Integer userId);

    /**
     * 更新购物车项
     * @param cartItem 购物车项
     * @return 影响行数
     */
    int update(CartItem cartItem);

    /**
     * 更新购物车项数量
     * @param id 购物车项ID
     * @param quantity 数量
     * @return 影响行数
     */
    int updateQuantity(@Param("id") Integer id, @Param("quantity") Integer quantity);

    /**
     * 删除购物车项
     * @param id 购物车项ID
     * @return 影响行数
     */
    int deleteById(Integer id);

    /**
     * 批量删除购物车项
     * @param ids 购物车项ID列表
     * @return 影响行数
     */
    int deleteByIds(@Param("ids") List<Integer> ids);

    /**
     * 清空用户购物车
     * @param userId 用户ID
     * @return 影响行数
     */
    int deleteByUserId(Integer userId);

    /**
     * 统计用户购物车商品数量
     * @param userId 用户ID
     * @return 商品数量
     */
    int countByUserId(Integer userId);
}
